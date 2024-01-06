const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.refreshAvailability = functions.pubsub.schedule('0 8 * * *') // Runs every day at 8 AM
    .timeZone('Asia/Kuala_Lumpur')
    .onRun(async (context) => {
        const firestore = admin.firestore();

        // Your logic to refresh availability in Firestore
        // For example, you can update documents based on your requirements

        return null;
    });
