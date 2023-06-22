const db = require('../models/models')
const notificationAdmin = require('./push_notification')

const updateLabresult = async (req, res) => {
    try {
        const labresult = await db.Labresult.findById(req.params.id);

        if (!labresult) {
            return res.status(404).json({ message: 'labresult not found' });
        }

        const isAuthorized =
            labresult.patient === req.user.id ||
            labresult.provider === req.user.id;

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const labresultUpdates = {};
        const labresultFields = ['test', 'result', 'date', 'reason', 'sharedwith'];

        labresultFields.forEach((field) => {
            if (req.body[field]) {
                labresultUpdates[field] = req.body[field];
            }
        });

        Object.assign(labresult, labresultUpdates);
        await labresult.save();
        const patient = await db.Patient.findById(labresult.patient);
        const provider = await db.HealthcareProvider.findById(req.user.id);

        if (labresult.provider === req.user.id) {
            const notification = new db.Notification({
                userId: labresult.patient,
                message: `Your lab result (${labresult._id}) has been updated by ${provider.name}`,
            });
            await notification.save();

            const notificationData = {
                id: notification._id,
                fileId: labresult._id,
                title: 'Updated Lab Result',
                body: `Your lab result (${labresult._id}) has been updated`,
            };
            await notificationAdmin.sendPushNotification(
                labresult.patient,
                notificationData
            );
        }

        if (labresult.sharedwith.length > 0) {
            const notifications = labresult.sharedwith.map((userId) => {
                return new db.Notification({
                    userId,
                    message: `The lab result (${labresult._id}) of the patient (${patient.name}) has been updated`,
                });
            });
            await db.Notification.insertMany(notifications);

            const notificationPromises = notifications.map((notification) => {
                const notificationData = {
                    id: notification._id,
                    fileId: labresult._id,
                    title: 'Updated Lab Result',
                    body: `The lab result (${labresult._id}) has been updated`,
                };
                return notificationAdmin.sendPushNotification(
                    notification.userId,
                    notificationData
                );
            });

            Promise.all(notificationPromises)
                .then(() => {
                    console.log('Notifications sent');
                    res.status(200).json({ message: 'Lab result updated successfully' });
                })
                .catch((error) => {
                    console.error('Error sending notifications:', error);
                    res
                        .status(500)
                        .json({ error: 'Failed to send notifications', message: 'Lab result updated successfully' });
                });
        } else {
            res.status(200).json({ message: 'Lab result updated successfully', _id: savedLabresult._id });
        }
    } catch (error) {
        console.error(error);
        res
            .status(500)
            .json({ error: 'An error occurred while updating the lab result' });
    }
};

const deleteLabresult = async (req, res) => {
    try {
        const labresult = await db.Labresult.findById(req.params.id);

        if (!labresult) {
            return res.status(404).json({ message: 'labresult not found' });
        }

        const isAuthorized =
            labresult.patient === req.user.id ||
            labresult.provider === req.user.id;

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const patient = await db.Patient.findById(labresult.patient);
        patient.labresult.pull(labresult._id);
        await patient.save();

        const provider = await db.HealthcareProvider.findById(req.user.id);

        if (labresult.provider === req.user.id) {
            const notification = new db.Notification({
                userId: labresult.patient,
                message: `Your lab result (${labresult._id}) has been deleted by ${provider.name}`,
            });
            await notification.save();

            const notificationData = {
                id: notification._id,
                title: 'Deleted Lab Result',
                body: `Your lab result (${labresult._id}) has been deleted`,
            };
            await notificationAdmin.sendPushNotification(
                labresult.patient,
                notificationData
            );
        }

        if (labresult.sharedwith.length > 0) {
            const notifications = labresult.sharedwith.map((userId) => {
                return new db.Notification({
                    userId,
                    message: `The lab result (${labresult._id}) of the patient (${patient.name}) has been deleted`,
                });
            });
            await db.Notification.insertMany(notifications);

            const notificationPromises = notifications.map((notification) => {
                const notificationData = {
                    id: notification._id,
                    title: 'Deleted Lab Result',
                    body: `The lab result (${labresult._id}) has been deleted`,
                };
                return notificationAdmin.sendPushNotification(
                    notification.userId,
                    notificationData
                );
            });

            Promise.all(notificationPromises)
                .then(() => {
                    console.log('Notifications sent');
                    res.status(200).json({ message: 'Lab result deleted successfully' });
                })
                .catch((error) => {
                    console.error('Error sending notifications:', error);
                    res
                        .status(500)
                        .json({ error: 'Failed to send notifications', message: 'Lab result deleted successfully' });
                });
        } else {
            res.status(200).json({ message: 'Lab result deleted successfully' });
        }

        await labresult.remove();

    } catch (error) {
        console.error(error);
        res
            .status(500)
            .json({ error: 'An error occurred while deleting the lab result' });
    }
};

const getlabresultById = async (req, res) => {
    try {
        const labresult = await db.Labresult.findById(req.params.id);

        if (!labresult) {
            return res.status(404).json({ message: 'labresult not found' });
        }

        const patient = await db.Patient.findById(labresult.patient);
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

        res.status(200).json({ status: true, data: labresult });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching the labresult' });
    }
};
const getLabProviderName = async (req, res) => {
    try {
        const labresult = await db.Labresult.findById(req.params.id);

        if (!labresult) {
            return res.status(404).json({ message: 'labresult not found' });
        }
        const provider = await db.User.findById(labresult.provider)
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
        res.status(500).json({ error: 'An error occurred while fetching the labresult' });
    }
}
const labresult = {
    updateLabresult,
    deleteLabresult,
    getlabresultById,
    getLabProviderName
}

module.exports = labresult