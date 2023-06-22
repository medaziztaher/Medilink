const express = require('express');
const router = express.Router();
const { verifyToken } = require("../middleware/authorization");
const allergy = require('../controllers/allergys');


router.get('/:id',verifyToken,allergy.getAllergy)


module.exports =router