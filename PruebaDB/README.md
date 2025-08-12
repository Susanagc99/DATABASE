#### 1. Install Dependencies
```bash
npm install
```

#### 2. Database Setup
```bash
# Create MySQL database
mysql -u root -p
CREATE DATABASE expertsoft;
USE expertsoft;
```

#### 3. Configure Database Connection
Edit `server/conexion_db.js` with your MySQL credentials:
```javascript
const pool = mysql.createPool({
    host: 'localhost',
    user: 'your_username',
    password: 'your_password',
    database: 'expertsoft'
});
```

### 🛠️ Technologies Used

- **Backend**: Node.js + Express.js
- **Database**: MySQL with mysql2 driver
- **Data Processing**: CSV parsing


# Run seeders to upload CSV
node server/seeders/run_seeders.js

# Start the server in development mode
node server/index.js

# Test endpoints with Postman
http://localhost:3000/<endpoint>

