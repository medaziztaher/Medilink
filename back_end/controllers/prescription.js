const db = require('../models/models');
const notificationAdmin = require('./push_notification')

const getPrescription = async (req, res) => {
  try {
    console.log(req.params)
    const prescription = await db.Prescription.findById(req.params.id);

    if (!prescription) {
      return res.status(404).json({ message: 'Prescription not found' });
    }

    const patient = await db.Patient.findById(prescription.patient);
    const isAuthorized =
      patient._id.toString() === req.user.id ||
      patient.healthcareproviders.some(
        provider =>
          provider.healthcareproviderId === req.user.id &&
          provider.status === 'Approved'
      );

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    res.status(200).json({status : true , data: prescription });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the prescription' });
  }
};

const updatePrescription = async (req, res) => {
  try {
    const prescription = await db.Prescription.findById(req.params.id);

    if (!prescription) {
      return res.status(404).json({ message: 'Prescription not found' });
    }

    const isAuthorized =
      prescription.patient === req.user.id ||
      prescription.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    prescription.médicament = req.body.médicament;
    prescription.dosage = req.body.dosage;
    prescription.fréquence = req.body.fréquence;
    prescription.dateDébut = req.body.dateDébut;
    prescription.dateFin = req.body.dateFin;
    prescription.reminderTime = req.body.reminderTime;

    const updatedPrescription = await prescription.save();
    const patient = await db.Patient.findById(updatedPrescription.patient);
    const provider = await db.HealthcareProvider.findById(updatedPrescription.provider);

    if (updatedPrescription.provider === req.user.id) {
      const notification = new db.Notification({
        userId: updatedPrescription.patient,
        message: `Your prescription ${updatedPrescription._id} has been updated by ${provider.name}`
      });
      await notification.save();
      const notificationData = {
        id: notification._id,
        fileId: updatedPrescription._id,
        title: 'Prescription updated',
        body: `Your prescription ${updatedPrescription._id} has been updated by ${provider.name}`
      };

      await notificationAdmin.sendPushNotification(
        updatedPrescription.patient,
        notificationData
      );

    }

    if (updatedPrescription.sharedwith.length > 0) {
      const notifications = updatedPrescription.sharedwith.map(userId => {
        const notification = new db.Notification({
          userId,
          message: `${patient.name} has updated one of his prescriptions`
        });
        return notification;
      });
      await db.Notification.insertMany(notifications);
      const notificationPromises = notifications.map((notification) => {
        const notificationData = {
          id: notification._id,
          fileId: updatedPrescription._id,
          title: 'Prescription updated',
          body: `${patient.name} has updated one of his prescriptions`
        };
        return notificationAdmin.sendPushNotification(
          notification.userId,
          notificationData
        );
      });

      Promise.all(notificationPromises)
        .then(() => {
          console.log('Notifications sent');
          res.status(200).json({ message: 'Prescription updated successfully' });
        })
        .catch((error) => {
          console.error('Error sending notifications:', error);
          res
            .status(500)
            .json({ error: 'Failed to send notifications', message: 'Prescription updated successfully' });
        });
    }

    res.status(200).json({ message: 'Prescription updated successfully', data: updatedPrescription });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while updating the prescription' });
  }
};

const deletePrescription = async (req, res) => {
  try {
    const prescription = await db.Prescription.findById(req.params.id);

    if (!prescription) {
      return res.status(404).json({ message: 'Prescription not found' });
    }

    const isAuthorized =
      prescription.patient === req.user.id ||
      prescription.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

   

    const patient = await db.Patient.findById(prescription.patient);
    patient.ordonnances.pull(prescription._id);
    await patient.save();

    const provider = await db.HealthcareProvider.findById(prescription.provider);

    if (prescription.provider === req.user.id) {
      const notification = new db.Notification({
        userId: prescription.patient,
        message: `Your prescription ${prescription._id} has been deleted by ${provider.name}`
      });
      await notification.save();
      const notificationData = {
        id: notification._id,
        title: 'Prescription deleted',
        body: `${provider.name} deleted your prescription`
      };

      await notificationAdmin.sendPushNotification(
        prescription.patient,
        notificationData
      );
    }

    if (prescription.sharedwith.length > 0) {
      const notifications = prescription.sharedwith.map(userId => {
        const notification = new db.Notification({
          userId,
          message: `The prescription of your patient ${patient.name} has been deleted`
        });
        return notification;
      });
      await db.Notification.insertMany(notifications);
      const notificationPromises = notifications.map((notification) => {
        const notificationData = {
            id: notification._id,
            title:'Prescription deleted',
            body: `The prescription of your patient ${patient.name} has been deleted`,
        };
        return notificationAdmin.sendPushNotification(
            notification.userId,
            notificationData
        );
    });

    Promise.all(notificationPromises)
        .then(() => {
            console.log('Notifications sent');
            res.status(200).json({ message: 'prescription deleted successfully' });
        })
        .catch((error) => {
            console.error('Error sending notifications:', error);
            res
                .status(500)
                .json({ error: 'Failed to send notifications', message: 'prescription deleted successfully' });
        });
    }


    await prescription.remove();
    res.status(200).json({ message: 'Prescription deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the prescription' });
  }
};

const getRadioProviderName = async (req, res) => {
  try {
      const prescription = await db.Prescription.findById(req.params.id);

      if (!prescription) {
          return res.status(404).json({ message: 'prescription not found' });
      }
      const provider = await db.User.findById(prescription.provider)
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
      res.status(500).json({ error: 'An error occurred while fetching the prescription' });
  }
}

const prescription = {
  getPrescription,
  updatePrescription,
  deletePrescription,
  getRadioProviderName
};

module.exports = prescription;