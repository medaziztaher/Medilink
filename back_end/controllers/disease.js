const db = require('../models/models')

const getdiseases = async (req, res) => {
    try {

        const diseases = await db.Diseases.findById(req.params.id);

        if (!diseases) {
            return res.status(404).json({ message: 'diseases not found' });
        }


        const patient = await db.Patient.findById(diseases.patient);
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

        res.status(200).json({ status: true, data: diseases });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred\n while fetching the diseases' });
    }
};


const diseases = {
    getdiseases,

}

module.exports = diseases