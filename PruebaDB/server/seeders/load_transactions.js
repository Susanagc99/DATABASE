/* se encarga de cargar los bills a la base de datos*/

import fs from 'fs';  //permite leer archivos
import path from 'path'; //muestra la ruta actual
import csv from 'csv-parser';
import { pool } from "../conexion_db.js"

export async function upload_transactionsDB() {

    const rutaArchivo = path.resolve('server/data/transactions.csv');
    const transactions = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(rutaArchivo)
            .pipe(csv())
            .on("data", (row) => {
                transactions.push([
                    row.transaction_id,
                    row.customer_id,
                    row.date_time,
                    row.amount,
                    row.platform
                ]);
            })
            .on('end', async () => {
                try {
                    const sql = 'INSERT INTO transactions(transaction_id,customer_id,date_time,amount,platform) VALUES ?';
                    const [result] = await pool.query(sql, [transactions]);

                    console.log(`✅ ${result.affectedRows} transactions were inserted.`);
                    resolve(); // finish successfully
                } catch (error) {
                    console.error('❌ Error inserting transactions:', error.message);
                    reject(error);
                }
            })
            .on('error', (error) => {
                console.error('❌ Error reading transactions CSV file:', error.message)
                reject(error);
            });
    })
}
