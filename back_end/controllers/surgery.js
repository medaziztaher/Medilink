const db = require('../models/models')
const notificationAdmin = require('./push_notification')

const getSurgery = async (req, res) => {
    try {
        console.log(req.params)
        const surgery = await db.Surgery.findById(req.params.id);

        if (!surgery) {
            return res.status(404).json({ message: 'Surgery not found' });
        }


        const patient = await db.Patient.findById(surgery.patient);
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

        res.status(200).json({ status: true, data: surgery });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred\n while fetching the surgery' });
    }
};

const updateSurgery = async (req, res) => {
    try {

        const surgery = await db.Surgery.findById(req.params.id);

        if (!surgery) {
            return res.status(404).json({ message: 'Surgery not found' });
        }


        const isAuthorized =
            surgery.patient === req.user.id ||
            surgery.provider === req.user.id;

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const surgeryUpdates = {};


        const surgeryFields = ['type', 'date', 'description', 'complications'];


        surgeryFields.forEach((field) => {
            if (req.body[field]) {
                surgeryUpdates[field] = req.body[field];
            }
        });


        Object.assign(surgery, surgeryUpdates);

        const updatedSurgery = await surgery.save();
        const patient = await db.Patient.findById(updatedSurgery.patient)
        const provider = await db.HealthcareProvider.findById(updatedSurgery.provider)

        if (updatedSurgery.provider === req.user.id) {
            const notification = new db.Notification({
                userId: updatedSurgery.patient,
                message: `${updatedSurgery.type} updated by ${provider.name}`
            })
            await notification.save()
            const notificationData = {
                id: notification._id,
                fileId: updatedSurgery._id,
                title: `${updatedSurgery.type} updated`,
                body: `${updatedSurgery.type} updated by ${provider.name}`,
            };
            await notificationAdmin.sendPushNotification(
                updatedSurgery.patient,
                notificationData
            );

        }

        if (updatedSurgery.sharedwith.length > 0) {
            const notifications = updatedSurgery.sharedwith.map(userId => {
                const notification = new db.Notification({
                    userId,
                    message: `Your patient  ${patient.name} added a new ${updatedSurgery.type}`
                })
                return notification;
            })
            await db.Notification.insertMany(notifications);
            const notificationPromises = notifications.map((notification) => {
                const notificationData = {
                    id: notification._id,
                    fileId: updatedSurgery._id,
                    title: `${updatedSurgery.type} updated`,
                    body: `Your patient  ${patient.name} added a new ${updatedSurgery.type}`,
                };
                return notificationAdmin.sendPushNotification(
                    notification.userId,
                    notificationData
                );
            });

            Promise.all(notificationPromises)
                .then(() => {
                    console.log('Notifications sent');
                    res.status(200).json({ message: `${updatedSurgery.type} updated successfully` });
                })
                .catch((error) => {
                    console.error('Error sending notifications:', error);
                    res
                        .status(500)
                        .json({ error: 'Failed to send notifications', message: `${updatedSurgery.type} updated successfully` });
                });
        }
        res.status(200).json({ message: `${updatedSurgery.type}updated successfully`, data: updatedSurgery });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred\n while updating the surgery' });
    }
};

const deleteSurgery = async (req, res) => {
    try {

        const surgery = await db.Surgery.findById(req.params.id);

        if (!surgery) {
            return res.status(404).json({ message: 'Surgery not found' });
        }


        const isAuthorized =
            surgery.patient === req.user.id ||
            surgery.provider === req.user.id;

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }





        const patient = await db.Patient.findById(surgery.patient);
        patient.surgeries.pull(surgery._id);
        await patient.save();

        const provider = await db.HealthcareProvider.findById(surgery.provider)

        if (surgery.provider === req.user.id) {
            const notification = new db.Notification({
                userId: surgery.patient,
                message: `${provider.name} deleted your ${surgery.type} `
            })
            await notification.save()
            const notificationData = {
                id: notification._id,
                title: `${surgery.type} deleted `,
                body: `${provider.name} deleted your ${surgery.type} `
            };

            await notificationAdmin.sendPushNotification(
                surgery.patient,
                notificationData
            );

        }

        if (surgery.sharedwith.length > 0) {
            const notifications = surgery.sharedwith.map(userId => {
                const notification = new db.Notification({
                    userId,
                    message: `${surgery.type} of your patient : ${patient.name} deleted `
                })
                return notification;
            })
            await db.Notification.insertMany(notifications);
            const notificationPromises = notifications.map((notification) => {
                const notificationData = {
                    id: notification._id,
                    title: `${surgery.type}  deleted `,
                    body: `${surgery.type} of your patient : ${patient.name} deleted `,
                };
                return notificationAdmin.sendPushNotification(
                    notification.userId,
                    notificationData
                );
            });

            Promise.all(notificationPromises)
                .then(() => {
                    console.log('Notifications sent');
                    res.status(200).json({ message: `${surgery.type}deleted successfully` });
                })
                .catch((error) => {
                    console.error('Error sending notifications:', error);
                    res
                        .status(500)
                        .json({ error: 'Failed to send notifications', message: `${surgery.type}deleted successfully` });
                });
        }
        await surgery.remove();
        res.status(200).json({ message: `${surgery.type} deleted successfully` });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred\n while deleting the surgery' });
    }
};



const getSurgeryProvider = async (req, res) => {
    try {
        const surgery = await db.Surgery.findById(req.params.id);

        if (!surgery) {
            return res.status(404).json({ message: 'surgery not found' });
        }
        const provider = await db.User.findById(surgery.provider)
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
        res.status(500).json({ error: 'An error occurred while fetching the surgery' });
    }
}



const surgery = {
    getSurgery,
    updateSurgery,
    deleteSurgery,
    getSurgeryProvider

}

module.exports = surgery