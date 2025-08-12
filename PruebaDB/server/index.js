import cors from "cors"
import express from "express"
import { pool } from "./conexion_db.js"

const app = express()
app.use(cors()) // this allows the backend application to be consumed by a frontend application
app.use(express.json()) // allows Express to automatically interpret the body as JSON when receiving a POST or PUT request.

app.get('/transactions', async (req, res) => {
    try {
        const [rows] = await pool.query(`
        SELECT 
            t.transaction_id,
            c.customer_id,
            c.customer_name,
            c.identification,
            t.date_time AS transaction_datetime,
            t.amount,
            t.platform
        FROM transactions t
        JOIN customers c ON t.customer_id = c.customer_id
        `);

        res.json(rows);

    } catch (error) {
        res.status(500).json({
            status: 'error',
            endpoint: req.originalUrl,
            method: req.method,
            message: error.message
        });
    }
});


app.get('/transactions/:customer_id', async (req, res) => {
    try {
        const { customer_id } = req.params

        const [rows] = await pool.query(`
        SELECT 
            t.transaction_id,
            c.customer_id,
            c.customer_name,
            c.identification,
            t.date_time AS transaction_datetime,
            t.amount,
            t.platform
        FROM transactions t
        JOIN customers c ON t.customer_id = c.customer_id WHERE c.customer_id = ?
        `, [customer_id]);

        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({
            status: 'error',
            endpoint: req.originalUrl,
            method: req.method,
            message: error.message
        });
    }
});


app.post('/transactions', async (req, res) => {
    try {
        const {
            customer_id,
            date_time,
            amount,
            platform
        } = req.body

        const query = `
        INSERT INTO transactions 
        (customer_id,date_time,amount,platform)
        VALUES (?, ?, ?, ?)
        `
        const values = [
            customer_id,
            date_time,
            amount,
            platform
        ]

        const [result] = await pool.query(query, values)

        res.status(201).json({
            mensaje: "transaction created successfully"
        })
    } catch (error) {
        res.status(500).json({
            status: 'error',
            endpoint: req.originalUrl,
            method: req.method,
            message: error.message
        });
    }
})

app.put('/transactions/:transaction_id', async (req, res) => {
    try {
        const { transaction_id } = req.params

        const {
            customer_id,
            date_time,
            amount,
            platform
        } = req.body

        const query = `
        UPDATE prestamos SET 
            customer_id = ?,
            date_time = ?,
            amount = ?,
            platform = ?
        WHERE transaction_id = ?
        `
        const values = [
            customer_id,
            date_time,
            amount,
            platform,
            transaction_id
        ]

        const [result] = await pool.query(query, values)

        if (result.affectedRows != 0) {
            return res.json({ message: "updated transaction" })
        }
    } catch (error) {
        res.status(500).json({
            status: 'error',
            endpoint: req.originalUrl,
            method: req.method,
            message: error.message
        });
    }
})

app.delete('/transactions/:transaction_id', async (req, res) => {
    try {
        const { transaction_id } = req.params

        const query = `
        DELETE FROM transactions WHERE transaction_id = ?
        `
        const values = [
            transaction_id
        ]

        const [result] = await pool.query(query, values)

        if (result.affectedRows != 0) {
            return res.json({ message: "transaction deleted" })
        }
    } catch (error) {
        res.status(500).json({
            status: 'error',
            endpoint: req.originalUrl,
            method: req.method,
            message: error.message
        });
    }
})



//Inicio del servidor cuando este todo listo
app.listen(3000, () => {
    console.log("Server prepared correctly on http://localhost:3000");
})