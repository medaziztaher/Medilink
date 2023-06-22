const router = require("express").Router();
const prescription =require('../controllers/prescription');
const { verifyToken } = require("../middleware/authorization");


router.get("/:id",verifyToken, prescription.getPrescription)
router.put("/:id",verifyToken, prescription.updatePrescription)
router.delete("/:id",verifyToken,prescription.deletePrescription)
router.get('/:id/provider',verifyToken,prescription.getRadioProviderName)

module.exports = router;