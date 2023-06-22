const mongoose = require('mongoose');

const symptomCheckSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient' },
  symptoms: [{ type: String, required: true }],
  date: { type: Date, default: Date.now },
  severity: String, 
  notes: String, 
});

const SymptomCheck = mongoose.model('SymptomCheck', symptomCheckSchema);

module.exports = SymptomCheck;
