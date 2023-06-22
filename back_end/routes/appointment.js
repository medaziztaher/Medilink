const express = require('express');
const router = express.Router();
const { verifyToken } = require("../middleware/authorization");
const appointment = require('../controllers/appointment')


router.post('/healthcareProvider/:id/appointment',verifyToken,appointment.addAppointment)
router.get('/:id',verifyToken,appointment.getAppointment)
router.put('/:appointmentId', verifyToken, appointment.updateAppointment);
router.delete('/:appointmentId', verifyToken, appointment.deleteAppointment);
router.get('/:patientId/appointments', verifyToken, appointment.getPatientAppointments);
router.get('/:providerId/appointments', verifyToken, appointment.getProviderAppointments);
router.get('/appointments')

module.exports =router