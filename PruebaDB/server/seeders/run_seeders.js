import { upload_billsDB } from "./load_bills.js";
import { upload_customersDB } from "./load_customers.js";
import { upload_transactionsDB } from "./load_transactions.js";

(async () => {
    try {
        console.log('Starting seeders...');

        await upload_customersDB()
        await upload_transactionsDB()
        await upload_billsDB()
        
    
        console.log('All seeders executed correctly')
    } catch (error) {

        console.error('❌ Error running seeders:', error.message);
    } finally {
        process.exit();
    }
})();