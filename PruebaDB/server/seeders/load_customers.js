/* se encarga de cargar los customers a la base de datos*/

import fs from 'fs';  //permite leer archivos
import path from 'path'; //muestra la ruta actual
import csv from 'csv-parser';
import { pool } from "../conexion_db.js"

export async function upload_customersDB() {

    const rutaArchivo = path.resolve('server/data/customers.csv');
    const customers = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(rutaArchivo)
            .pipe(csv())
            .on("data", (row) => {
                customers.push([
                    row.customer_id,
                    row.customer_name,
                    row.identification,
                    row.address,
                    row.phone_number,
                    row.email
                ]);
            })
            .on('end', async () => {
                try {
                    const sql = 'INSERT INTO customers(customer_id,customer_name,identification,address,phone_number,email) VALUES ?';
                    const [result] = await pool.query(sql, [customers]);

                    console.log(`✅ ${result.affectedRows} customers were inserted.`);
                    resolve(); // finish successfully
                } catch (error) {
                    console.error('❌ Error inserting customers:', error.message);
                    reject(error);
                }
            })
            .on('error', (error) => {
                console.error('❌ Error reading customers CSV file:', error.message)
                reject(error);
            });
    })
}
