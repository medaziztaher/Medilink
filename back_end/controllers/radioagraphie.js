const db = require('../models/models');
const notificationAdmin = require('./push_notification')


const getRadiographie = async (req, res) => {
  try {
    const radiographie = await db.Radiographies.findById(req.params.id);

    if (!radiographie) {
      return res.status(404).json({ message: 'Radiographie not found' });
    }

    const patient = await db.Patient.findById(radiographie.patient);
    const isAuthorized =
      patient._id === req.user.id ||
      patient.healthcareproviders.some(
        provider =>
          provider.healthcareproviderId === req.user.id &&
          provider.status === 'Approved'
      );

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    res.status(200).json({ status: true, data: radiographie });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the radiographie' });
  }
};

const updateRadiographie = async (req, res) => {
  try {
    const radiographie = await db.Radiographies.findById(req.params.id);

    if (!radiographie) {
      return res.status(404).json({ message: 'Radiographie not found' });
    }

    const isAuthorized =
      radiographie.patient === req.user.id ||
      radiographie.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    const radiographieUpdates = {};
    const radiographieFields = ['type', 'date', 'description', 'reason'];

    radiographieFields.forEach((field) => {
      if (req.body[field]) {
        radiographieUpdates[field] = req.body[field];
      }
    });

    Object.assign(radiographie, radiographieUpdates);

    const updatedRadiographie = await radiographie.save();
    const patient = await db.Patient.findById(updatedRadiographie.patient)
    const provider = await db.HealthcareProvider.findById(updatedRadiographie.provider)

    if (updatedRadiographie.provider === req.user.id) {
      const notification = new db.Notification({
        userId: updatedRadiographie.patient,
        message: `${updatedRadiographie.type}: ${updatedRadiographie._id} updated by ${provider.name}`
      })
      await notification.save()
      const notificationData = {
        id: notification._id,
        fileId: updatedRadiographie._id,
        title: `${updatedRadiographie.type} updated`,
        body: `${updatedRadiographie.type} updated by ${provider.name}`
      };

      await notificationAdmin.sendPushNotification(
        updatedRadiographie.patient,
        notificationData
      );
    }

    if (updatedRadiographie.sharedwith.length > 0) {
      const notifications = updatedRadiographie.sharedwith.map(userId => {
        const notification = new db.Notification({
          userId,
          message: `${updatedRadiographie.type}: ${updatedRadiographie._id} of the patient : ${patient.name} updated `
        })
        return notification;
      })
      await db.Notification.insertMany(notifications);
      const notificationPromises = notifications.map((notification) => {
        const notificationData = {
          id: notification._id,
          fileId: updatedRadiographie._id,
          title: 'New prescription added',
          body: `Your patient ${patient.name} added a new ${updatedRadiographie.type}`,
        };
        return notificationAdmin.sendPushNotification(
          notification.userId,
          notificationData
        );
      });

      Promise.all(notificationPromises)
        .then(() => {
          console.log('Notifications sent');
          res.status(200).json({ message: `${updatedRadiographie.type} updated successfully` });
        })
        .catch((error) => {
          console.error('Error sending notifications:', error);
          res
            .status(500)
            .json({ error: 'Failed to send notifications', message: `${updatedRadiographie.type} updated successfully` });
        });
    }

    res.status(200).json({ message: `${updatedRadiographie.type} updated successfully`, data: updatedRadiographie, _id: updateRadiographie._id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while updating the radiographie' });
  }
};

const deleteRadiographie = async (req, res) => {
  try {
    const radiographie = await db.Radiographies.findById(req.params.id);

    if (!radiographie) {
      return res.status(404).json({ message: 'Radiographie not found' });
    }

    const isAuthorized =
      radiographie.patient === req.user.id ||
      radiographie.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }



    const patient = await db.Patient.findById(radiographie.patient);
    patient.radiographies.pull(radiographie._id);
    await patient.save();

    const provider = await db.HealthcareProvider.findById(radiographie.provider)

    if (radiographie.provider === req.user.id) {
      const notification = new db.Notification({
        userId: radiographie.patient,
        message: `${provider.name} deleted your ${radiographie.type} `
      })
      await notification.save()
      const notificationData = {
        id: notification._id,
        title: `${radiographie.type} deleted `,
        body: `${provider.name} deleted your ${radiographie.type} `
      };

      await notificationAdmin.sendPushNotification(
        radiographie.patient,
        notificationData
      );
    }

    if (radiographie.sharedwith.length > 0) {
      const notifications = radiographie.sharedwith.map(userId => {
        const notification = new db.Notification({
          userId,
          message: `${radiographie.type} of your patient : ${patient.name} deleted `
        })
        return notification;
      })
      await db.Notification.insertMany(notifications);
      const notificationPromises = notifications.map((notification) => {
        const notificationData = {
          id: notification._id,
          title: `${radiographie.type} deleted `,
          body: `${radiographie.type} of your patient : ${patient.name} deleted `,
        };
        return notificationAdmin.sendPushNotification(
          notification.userId,
          notificationData
        );
      });

      Promise.all(notificationPromises)
        .then(() => {
          console.log('Notifications sent');
          res.status(200).json({ message: `${radiographie.type} deleted successfully` });
        })
        .catch((error) => {
          console.error('Error sending notifications:', error);
          res
            .status(500)
            .json({ error: 'Failed to send notifications', message: `${radiographie.type} deleted successfully` });
        });

    }
    await radiographie.remove();
    res.status(200).json({ message: `${radiographie.type} deleted successfully` });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the radiographie' });
  }
};

const getRadioProviderName = async (req, res) => {
  try {
      const radiographie = await db.Radiographies.findById(req.params.id);

      if (!radiographie) {
          return res.status(404).json({ message: 'radiographie not found' });
      }
      const provider = await db.User.findById(radiographie.provider)
      if (!provider) {
          return;
      }
      res.status(200).json({
          status: true,
          data: {
              provider: provider.name
          }
      });
  } catch (e) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while fetching the radiographie' });
  }
}

const radiographie = {
  getRadiographie,
  updateRadiographie,
  deleteRadiographie,
  getRadioProviderName
};

module.exports = radiographie;
