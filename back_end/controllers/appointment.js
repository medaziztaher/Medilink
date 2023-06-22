const db = require('../models/models')
const notificationAdmin = require('./push_notification')

const addAppointment = async (req, res) => {
  try {
    const provider = await db.HealthcareProvider.findById(req.params.id);
    const patient = await db.Patient.findById(req.user.id);

    if (!patient) {
      return res.status(404).json({ message: 'Only patients can book an appointment' });
    }

    if (!provider) {
      return res.status(404).json({ message: 'Provider not found' });
    }

    const isAuthorized = provider.patients.some(
      (patient) =>
        patient.patientId === req.user.id &&
        patient.status === 'Approved'
    );

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    const appointment = new db.Appointment({
      patient: req.user.id,
      provider: req.params.id,
      date: req.body.date,
      time: req.body.time,
      reason: req.body.reason,
    });

    const savedAppointment = await appointment.save();

    provider.appointment.push(savedAppointment._id);
    patient.appointment.push(savedAppointment._id);

    await provider.save();
    await patient.save();

    const notification = new db.Notification({
      userId: provider._id,
      message: `You have a new appointment request from ${patient.name} at ${savedAppointment.time} ${savedAppointment.date}`,
    });
    await notification.save();

    const userId = provider._id;
    const notificationData = {
      id: notification._id,
      fileId: savedAppointment._id,
      title: 'New Appointment',
      body: `You have a new appointment request from ${patient.name} at ${savedAppointment.time} ${savedAppointment.date}`,
    };

    notificationAdmin
      .sendPushNotification(userId, notificationData)
      .then(() => {
        console.log('Notification sent');
        res.status(201).json({ message: 'Appointment added successfully' });
      })
      .catch((error) => {
        console.error('Error sending notification:', error);
        res.status(500).json({ error: 'Failed to send notification' });
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while adding the appointment' });
  }
};

const getTodayAppointments = async (req, res) => {
  const userId = req.userId;
  try {
    const today = new Date();
    const startOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    const endOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);

    const appointments = await db.Appointment.find({
      $or: [{ patient: userId }, { provider: userId }],
      date: {
        $gte: startOfDay,
        $lt: endOfDay
      }
    })
      .populate('patient')
      .populate('provider');

    for (let i = 0; i < appointments.length; i++) {
      const appointment = appointments[i];
      if (appointment.date < today && appointment.status === 'Scheduled') {
        appointment.status = 'Completed';
        await appointment.save();
      }
    }

    const patient = await db.User.findById(appointments.patient)
    const provider = await db.User.findById(appointments.provider)

    res.send({ data: appointments, provider: provider, patient: patient });
  } catch (err) {
    console.error(err);
    res.status(500).send(err);
  }
}

const getAppointment = async (req, res) => {
  try {
    const appointment = await db.Appointment.findById(req.params.id);

    if (!appointment) {
      return res.status(404).json({ message: 'appointment not found' });
    }

    const isAuthorized =
      appointment.patient === req.user.id ||
      appointment.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }
    res.status(200).json({ data: appointment });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the appointment' });
  }
};

const updateAppointment = async (req, res) => {
  try {
    const appointment = await db.Appointment.findById(req.params.appointmentId);

    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    const isAuthorized =
      appointment.patient === req.user.id ||
      appointment.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    appointment.date = req.body.date || appointment.date;
    appointment.time = req.body.time || appointment.time;
    appointment.reason = req.body.reason || appointment.reason;

    const updatedAppointment = await appointment.save();
    const provider = await db.HealthcareProvider.findById(appointment.provider);
    const patient = await db.Patient.findById(appointment.patient);

    let recipientId, recipientName, isDoctor;
    if (appointment.patient === req.user.id) {
      recipientId = appointment.provider;
      recipientName = patient.name;
      isDoctor = false;
    } else {
      recipientId = appointment.patient;
      recipientName = provider.name;
      isDoctor = true;
    }
    const notification = new db.Notification({
      userId: recipientId,
      message: `Your appointment with${isDoctor ? ' Dr.' : ''} ${recipientName} has been updated to ${appointment.date} ${appointment.time}`,
    });

    await notification.save();

    const userId = recipientId;
    const notificationData = {
      id: notification._id,
      fileId: updatedAppointment._id,
      title: 'Updated Appointment',
      body: `Your appointment with${isDoctor ? ' Dr.' : ''} ${recipientName} has been updated to ${appointment.date} ${appointment.time}`,
    };

    await notificationAdmin
      .sendPushNotification(userId, notificationData)

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while updating the appointment' });
  }
};

const deleteAppointment = async (req, res) => {
  try {
    const appointment = await db.Appointment.findById(req.params.appointmentId);

    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    const isAuthorized =
      appointment.patient === req.user.id ||
      appointment.provider === req.user.id;

    if (!isAuthorized) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    const provider = await db.HealthcareProvider.findById(appointment.provider);
    const patient = await db.Patient.findById(appointment.patient);

    provider.appointment.pull(appointment._id);
    patient.appointment.pull(appointment._id);

    await provider.save();
    await patient.save();

    let recipientId, recipientName, isDoctor;
    if (appointment.patient === req.user.id) {
      recipientId = appointment.provider;
      recipientName = patient.name;
      isDoctor = false;
    } else {
      recipientId = appointment.patient;
      recipientName = provider.name;
      isDoctor = true;
    }
    const notification = new db.Notification({
      userId: recipientId,
      message: `Your appointment with${isDoctor ? ' Dr.' : ''} ${recipientName} has been deleted`,
    });
    await notification.save();

    const userId = recipientId;
    const notificationData = {
      id: notification._id,
      title: 'Deleted Appointment',
      body: `Your appointment with${isDoctor ? ' Dr.' : ''} ${recipientName} has been deleted`,
    };
    await notificationAdmin.sendPushNotification(userId, notificationData)

    await appointment.remove()

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the appointment' });
  }
};

const getPatientAppointments = async (req, res) => {
  try {
    const patient = await db.Patient.findById(req.params.patientId);

    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    if (patient._id !== req.user.id) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    const appointments = await db.Appointment.find({ patient: patient._id });

    const today = new Date();
    for (let i = 0; i < appointments.length; i++) {
      const appointment = appointments[i];
      if (appointment.date < today && appointment.status === 'Scheduled') {
        appointment.status = 'Completed';
        await appointment.save();
      }
    }

    res.status(200).json({ data: appointments });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the patient appointments' });
  }
};

const getProviderAppointments = async (req, res) => {
  try {
    const provider = await db.HealthcareProvider.findById(req.params.providerId);

    if (!provider) {
      return res.status(404).json({ message: 'Healthcare provider not found' });
    }

    if (provider._id !== req.user.id) {
      return res.status(403).json({ message: 'Unauthorized access' });
    }

    const appointments = await db.Appointment.find({ provider: provider._id });

    const today = new Date();
    for (let i = 0; i < appointments.length; i++) {
      const appointment = appointments[i];
      if (appointment.date < today && appointment.status === 'Scheduled') {
        appointment.status = 'Completed';
        await appointment.save();
      }
    }

    res.status(200).json({ data: appointments });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching the provider appointments' });
  }
};

const appointment = {
  addAppointment,
  getAppointment,
  updateAppointment,
  deleteAppointment,
  getPatientAppointments,
  getProviderAppointments,
  getTodayAppointments
}

module.exports = appointment