import mysql from 'mysql2/promise'

export const pool = mysql.createPool({
    host: "localhost",
    database: "expertsoft",
    port: "3306",
    user: "root",
    password: "Qwe.123*",
})


async function testconnectionDatabase() {
    try {
        const connection = await pool.getConnection();
        console.log('✅ Connection to the database successful');
        connection.release();
    } catch (error) {
        console.error('❌ Error connecting to database:', error.message);
    }
}

testconnectionDatabase()