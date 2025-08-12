/* se encarga de cargar los bills a la base de datos*/

import fs from 'fs';  //permite leer archivos
import path from 'path'; //muestra la ruta actual
import csv from 'csv-parser';
import { pool } from "../conexion_db.js"

export async function upload_billsDB() {

    const rutaArchivo = path.resolve('server/data/bills.csv');
    const bills = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(rutaArchivo)
            .pipe(csv())
            .on("data", (row) => {
                bills.push([
                    row.bill_num,
                    row.transaction_id,
                    row.period,
                    row.bill_amount,
                    row.paid_amount,
                    row.state,
                ]);
            })
            .on('end', async () => {
                try {
                    const sql = 'INSERT INTO bills(bill_num,transaction_id,period,bill_amount,paid_amount,state) VALUES ?';
                    const [result] = await pool.query(sql, [bills]);

                    console.log(`✅ ${result.affectedRows} bills were inserted.`);
                    resolve(); // finish successfully
                } catch (error) {
                    console.error('❌ Error inserting bills:', error.message);
                    reject(error);
                }
            })
            .on('error', (error) => {
                console.error('❌ Error reading bills CSV file:', error.message)
                reject(error);
            });
    })
}
