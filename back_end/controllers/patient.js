const db = require('../models/models');
const notificationAdmin = require('./push_notification')




const getHealthcareProviders = async (req, res) => {
    try {
        console.log("user : ", req.user)
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }
        const providersIds = patient.healthcareproviders
            .filter((p) => p.status === "Approved")
            .map((p) => p.healthcareproviderId);
        const healthcareProviders = await db.HealthcareProvider.find({ _id: providersIds });
        console.log("provider : ", healthcareProviders)
        res.status(200).json({ status: true, data: healthcareProviders });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching healthcare providers' });
    }
};
const searchProviders = async (req, res) => {
    let pattern = req.body.pattern;
    let patientId = req.params.patientId;
    let regex = new RegExp(pattern, "i");
    try {
        let query = {
            $or: [
                { name: { $regex: regex } },
                { type: { $regex: regex } },
                { speciality: { $regex: regex } }
            ]
        };
        let patient = await db.Patient.findById(patientId);
        console.log("patien : ", patient)
        const providersIds = patient.healthcareproviders.map((p) => p.patientId);
        console.log("providers  Ids  : ", providersIds)
        const providers = await db.HealthcareProvider.find(providersIds);
        console.log("Providers : ", providers)
        res.status(200).json(providers);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: 'An error occurred' });
    }
};


const getProviderIdFromName = async (req, res) => {
    const { name } = req.params;

    try {
        const provider = await db.Provider.findOne({ name: name });
        console.log(provider);
        if (!provider) {
            return res.status(404).json({ message: 'Provider not found' });
        }

        res.status(200).json({ providerId: provider._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching the provider ID' });
    }
};

const getPrescriptionsCurrent = async (req, res) => {
    try {

        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

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

        const prescriptions = await db.Prescription.find({ patient: patient._id });


        res.status(200).json({ status: true, data: prescriptions });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching medical records' });
    }
};

const addPrescription = async (req, res) => {
    try {
        console.log(req.params)
        const patient = await db.Patient.findById(req.params.patientId);
        //console.log(patient)

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );
        console.log(req.user.id)
        console.log(isAuthorized)
        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }
        console.log("isAuthorized", isAuthorized);
        let provider = null;

        if (req.user.id !== patient._id) {
            provider = req.user.id;
        }

        const prescription = await db.Prescription.create({
            patient: patient._id,
            provider: provider,
            médicament: req.body.médicament,
            dosage: req.body.dosage,
            fréquence: req.body.fréquence,
            dateDébut: req.body.dateDébut,
            dateFin: req.body.dateFin,
        });

        const savedPrescription = await prescription.save();
        console.log("saved presc : ", savedPrescription)
        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { prescriptions: savedPrescription._id } }
        );
        console.log("saved", savedPrescription.provider)
        if (savedPrescription.provider === req.user.id) {
            console.log(notification)
            const notification = new db.Notification({
                userId: savedPrescription.patient,
                message: `You have a new prescription added by ${provider.name}`
            });
            await notification.save();
            const notificationData = {
                id: notification._id,
                fileId: savedPrescription._id,
                title: 'New prescription added',
                body: `You have a new prescription added by ${provider.name}`
            };

            await notificationAdmin.sendPushNotification(
                savedPrescription.patient,
                notificationData
            );
        }

        /*
                if (savedPrescription.sharedwith.length > 0) {
                    const notifications = savedPrescription.sharedwith.map(userId => {
                        const notification = new db.Notification({
                            userId,
                            message: `Your patient ${patient.name} added a new prescription`
                        });
                        return notification;
                    });
                    await db.Notification.insertMany(notifications);
                    const notificationPromises = notifications.map((notification) => {
                        const notificationData = {
                            id: notification._id,
                            fileId: savedPrescription._id,
                            title: 'New prescription added',
                            body: `Your patient ${patient.name} added a new prescription`,
                        };
                        return notificationAdmin.sendPushNotification(
                            notification.userId,
                            notificationData
                        );
                    });
        
                    Promise.all(notificationPromises)
                        .then(() => {
                            console.log('Notifications sent');
                            res.status(200).json({ message: 'New prescription added successfully' });
                        })
                        .catch((error) => {
                            console.error('Error sending notifications:', error);
                            res
                                .status(500)
                                .json({ error: 'Failed to send notifications', message: 'New prescription added successfully' });
                        });
                }
        */
        console.log(savedPrescription),

            res.status(201).json({ message: "New prescription added successfully", data: savedPrescription, _id: savedPrescription._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the prescription' });
    }
};

const getlabresult = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const labresult = await db.Labresult.find({ patient: patient._id });

        res.status(200).json({ status: true, data: labresult });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching lab results' });
    }
};

const getSymptomChecks = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.patientId);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const symptomChecks = await db.SymptomChecker.find({ patient: patient._id });

        res.status(200).json({ data: symptomChecks });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching symptom checks' });
    }
};

const addSymptomCheck = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const newSymptomCheck = new db.SymptomChecker({
            patient: patient._id,
            symptoms: req.body.symptoms,
            severity: req.body.severity,
            notes: req.body.notes,
        });

        const savedSymptomCheck = await newSymptomCheck.save();

        patient.symptomChecks.push(savedSymptomCheck._id);
        await patient.save();

        res.status(201).json({ data: savedSymptomCheck });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the symptom check' });
    }
};

const getSurgeries = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const surgeries = await db.Surgery.find({ patient: patient._id });

        res.status(200).json({ status: true, data: surgeries });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching surgeries' });
    }
};

const addSurgery = async (req, res) => {
    try {
        console.log(req.params)
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        let provider = null;

        if (req.user.id !== patient._id) {
            provider = req.user.id;
        }

        const surgery = new db.Surgery({
            patient: patient._id,
            provider: provider,
            type: req.body.type,
            date: req.body.date,
            description: req.body.description,
            complications: req.body.complications,
        });

        const savedSurgery = await surgery.save();
        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { surgeries: savedSurgery._id } }
        );

        if (savedSurgery.provider === req.user.id) {
            const notification = new db.Notification({
                userId: savedSurgery.patient,
                message: `You have a new surgery added by ${provider.name}`,
            });
            await notification.save();
            const notificationData = {
                id: notification._id,
                fileId: savedSurgery._id,
                title: 'New surgery added',
                body: `You have a new prescription added by ${provider.name}`
            };

            await notificationAdmin.sendPushNotification(
                savedSurgery.patient,
                notificationData
            );
        }

        const notifications = await Promise.all(savedSurgery.sharedwith.map(async (name) => {
            const user = await db.User.findOne({ name: name });
            const notification = new db.Notification({
                userId: user._id,
                message: `Your patient ${patient.name} added a new surgery`,
            });
            await notification.save();
            return notification;
        }));

        console.log("Notifications:", notifications);


        notifications.map((notification) => {
            const notificationData = {
                id: notification._id,
                fileId: savedSurgery._id,
                title: 'New surgery added',
                body: `Your patient ${patient.name} added a new surgery`,
            };
            return notificationAdmin.sendPushNotification(
                notification.userId,
                notificationData
            );
        });

        console.log('Notifications sent');
        res.status(201).json({ message: 'New surgery added successfully', data: savedSurgery, _id: savedSurgery._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the surgery' });
    }
};

const addLabresult = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Laboratoire'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        let provider = null;

        if (req.user.id !== patient._id) {
            provider = req.user.id;
        }

        const labresult = new db.Labresult({
            patient: patient._id,
            provider: provider,
            test: req.body.test,
            result: req.body.result,
            date: req.body.date,
            reason: req.body.reason,
            sharedwith: req.body.sharedwith
        });

        const savedLabresult = await labresult.save();

        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { labresult: savedLabresult._id } }
        );

        console.log("Saved LAB Shared With:", savedLabresult.sharedwith);

        if (savedLabresult.provider !== null && savedLabresult.provider === req.user.id) {
            const providerUser = await db.User.findById(req.user.id);
            const providerNotification = new db.Notification({
                userId: savedLabresult.patient,
                message: `You have a new lab result added by ${providerUser.name}`,
            });
            await providerNotification.save();
            const providerNotificationData = {
                id: providerNotification._id,
                fileId: savedLabresult._id,
                title: 'New lab result added',
                body: `You have a new lab result added by ${providerUser.name}`,
            };

            await notificationAdmin.sendPushNotification(
                savedLabresult.patient,
                providerNotificationData
            );
        }

        const notifications = await Promise.all(savedLabresult.sharedwith.map(async (name) => {
            const user = await db.User.findOne({ name: name });
            const notification = new db.Notification({
                userId: user._id,
                message: `Your patient ${patient.name} added a new lab result`,
            });
            await notification.save();
            return notification;
        }));

        console.log("Notifications:", notifications);


        notifications.map((notification) => {
            const notificationData = {
                id: notification._id,
                fileId: savedLabresult._id,
                title: 'New lab result added',
                body: `Your patient ${patient.name} added a new lab result`,
            };
            return notificationAdmin.sendPushNotification(
                notification.userId,
                notificationData
            );
        });

        console.log('Notifications sent');
        res.status(200).json({ message: 'New lab result added successfully', _id: savedLabresult._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the lab result' });
    }
};

const getRadiographies = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const radiographies = await db.Radiographies.find({ patient: patient._id });

        res.status(200).json({ status: true, data: radiographies });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching radiographies' });
    }
};

const addRadiographie = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === "Center d'imagerie Medicale"
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        let provider = null;

        if (req.user.id !== patient._id) {
            provider = req.user.id;
        }

        const radiographie = new db.Radiographies({
            patient: patient._id,
            provider: provider,
            type: req.body.type,
            description: req.body.description,
            date: req.body.date,
            reason: req.body.reason,
        });

        const savedRadio = await radiographie.save();
        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { radiographies: savedRadio._id } }
        );


        if (savedRadio.provider === req.user.id) {
            const notification = new db.Notification({
                userId: savedRadio.patient,
                message: `You have a new ${savedRadio.type} added by ${provider.name}`,
            });
            await notification.save();
            const notificationData = {
                id: notification._id,
                fileId: savedRadio._id,
                title: `New ${savedRadio.type} added `,
                body: `You have a new labresult added by ${provider.name}`
            };

            await notificationAdmin.sendPushNotification(
                savedRadio.patient,
                notificationData
            );

        }

        const notifications = await Promise.all(savedRadio.sharedwith.map(async (name) => {
            const user = await db.User.findOne({ name: name });
            const notification = new db.Notification({
                userId: user._id,
                message: `Your patient ${patient.name} added a new ${savedRadio.type}`,
            });
            await notification.save();
            return notification;
        }));

        console.log("Notifications:", notifications);


        notifications.map((notification) => {
            const notificationData = {
                id: notification._id,
                fileId: savedRadio._id,
                title: 'New ${savedRadio.type} added',
                body: `Your patient ${patient.name} added a new ${savedRadio.type}`,
            };
            return notificationAdmin.sendPushNotification(
                notification.userId,
                notificationData
            );
        });
        res.status(201).json({ message: `New ${savedRadio.type} added successfully`, data: savedRadio, _id: savedRadio._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the radiographie' });
    }
};

const getHealthJournals = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const healthJournals = await db.HealthJournal.find({ patient: patient._id });

        res.status(200).json({ data: healthJournals });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching health journals' });
    }
};

const addHealthJournalEntry = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const healthJournalEntry = new db.HealthJournal({
            patient: patient._id,
            date: req.body.date,
            symptoms: req.body.symptoms,
            mood: req.body.mood,
            activityLevel: req.body.activityLevel,
            sleepDuration: req.body.sleepDuration,
            medicationTaken: req.body.medicationTaken,
            notes: req.body.notes,
        });

        const savedEntry = await healthJournalEntry.save();

        patient.healthjournals.push(savedEntry._id);
        await patient.save();

        res.status(201).json({ data: savedEntry });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the health journal entry' });
    }
};

const getEmergencyContacts = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const isAuthorized =
            patient._id.toString() === req.user.id ||
            patient.healthcareproviders.some(
                provider =>
                    provider.healthcareproviderId === req.user.id &&
                    provider.status === 'Approved' &&
                    provider.type === 'Doctor'
            );

        if (!isAuthorized) {
            return res.status(403).json({ message: 'Unauthorized access' });
        }

        const emergencyContacts = await db.EmergencyContact.find({ patient: patient._id });

        res.status(200).json({ data: emergencyContacts });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching emergency contacts' });
    }
};

const addEmergencyContact = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const emergencyContact = new db.EmergencyContact({
            patient: patient._id,
            name: req.body.name,
            phoneNumber: req.body.phoneNumber,
            relationship: req.body.relationship,
        });

        const savedEmergencyContact = await emergencyContact.save();

        patient.emergencyContacts.push(savedEmergencyContact._id);
        await patient.save();

        res.status(201).json({ data: savedEmergencyContact });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the emergency contact' });
    }
};

const getPatientAllergies = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

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

        const allergies = await db.Allergy.find({ patient: patient._id });

        res.json({ data: allergies });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while retrieving the patient\'s allergies' });
    }
};

const addAllergy = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const allergy = new db.Allergy({
            patient: patient._id,
            type: req.body.type,
            name: req.body.name,
            yearOfDiscovery: req.body.yearOfDiscovery,
            followupStatus: req.body.followupStatus,
            familyHistory: req.body.familyHistory,
            notes: req.body.notes,
        });

        const savedAllergy = await allergy.save();
        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { allergys: savedAllergy._id } }
        );


        res.status(200).json({ data: savedAllergy, status: true, _id: savedAllergy._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the allergy' });
    }
};

const getPatientDiseases = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.params.patientId);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

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

        const diseases = await db.Diseases.find({ patient: patient._id });

        res.json({ data: diseases, status: true });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while retrieving the patient\'s diseases' });
    }
};

const addPatientDisease = async (req, res) => {
    try {
        const patient = await db.Patient.findById(req.user.id);

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        const disease = await db.Diseases.create({
            patient: patient._id,
            speciality: req.body.speciality,
            genetic: req.body.genetic,
            chronicDisease: req.body.chronicDisease,
            detectedIn: req.body.detectedIn,
            curedIn: req.body.curedIn,
            notes: req.body.notes,
        });

        const savedDisease = await disease.save();
        await db.Patient.updateOne(
            { _id: patient._id },
            { $push: { diseases: savedDisease._id } }
        );

        res.status(201).json({ status: true, data: disease, _id: savedDisease._id });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while adding the disease' });
    }
};

const patient = {
    getHealthcareProviders,
    getEmergencyContacts,
    getHealthJournals,
    getPatientAllergies,
    getPatientDiseases,
    getPrescriptionsCurrent,
    getRadiographies,
    getSurgeries,
    getSymptomChecks,
    addAllergy,
    addEmergencyContact,
    addHealthJournalEntry,
    addPatientDisease,
    addPrescription,
    addRadiographie,
    addSurgery,
    addSymptomCheck,
    getlabresult,
    addLabresult,
    getProviderIdFromName,
    searchProviders
}


module.exports = patient