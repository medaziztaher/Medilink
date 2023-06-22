const mongoose = require('mongoose');

const mriRecordSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true },
  provider: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false },
  type: { type: String, required: true },
  description: { type: String, required: true },
  date: { type: Date, required: true },
  reason: { type: String, required: true },
  result: [{
    id: String,
    url: String
  }],
  sharedwith : [{type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }]
});

const Radiographie = mongoose.model('Radiographie', mriRecordSchema);

module.exports = Radiographie;
