const express = require('express');
const router = express.Router();
const { verifyToken } = require("../middleware/authorization");
const disease = require('../controllers/disease');


router.get('/:id', verifyToken, disease.getdiseases)


module.exports = router