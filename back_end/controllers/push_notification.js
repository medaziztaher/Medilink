const fs = require("fs");
const path = require('path');
const FCM = require('fcm-node');
const db = require('../models/models');

const sendPushNotification = async (userId, message) => {
  try {
    console.log('User Id: ' + userId);
    console.log('Message: ' + message);

    fs.readFile(path.join(__dirname, '../firebaseConfig.json'), "utf8", async (err, jsonString) => {
      if (err) {
        console.log("Error reading file from disk:", err);
        return err;
      }

      try {
       
        const data = JSON.parse(jsonString);
        const serverKey = data.SERVER_KEY;
        const fcm = new FCM(serverKey);

        
        const user = await db.User.findById(userId);
        if (!user) {
          console.log('User not found');
          return;
        }

        
        const deviceToken = user.deviceToken;
        if (!deviceToken) {
          console.log('Device token not found for the user');
          return;
        }

       
        const pushMessage = {
          to: deviceToken,
          notification: {
            title: message.title,
            body: message.body,
          },
          data: {
            id: String(message.id),
            fileId: String(message.fileId),
          },
        };

        fcm.send(pushMessage, (err, response) => {
          if (err) {
            console.log('Error sending push notification:', err);
          } else {
            console.log('Push notification sent successfully:', response);
          }
        });
      } catch (err) {
        console.log("Error parsing JSON string:", err);
      }
    });
  } catch (error) {
    console.log(error);
  }
};

module.exports = { sendPushNotification };
