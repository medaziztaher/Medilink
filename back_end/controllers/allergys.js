const db = require('../models/models')

const getAllergy = async (req, res) => {
    try {
      
        const allergy = await db.Allergy.findById(req.params.id);

        if (!allergy) {
            return res.status(404).json({ message: 'allergy not found' });
        }

      
        const patient = await db.Patient.findById(allergy.patient);
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

        res.status(200).json({status: true , data: allergy });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred\n while fetching the allergy' });
    }
};


const allergy = {
    getAllergy,

}

module.exports = allergy