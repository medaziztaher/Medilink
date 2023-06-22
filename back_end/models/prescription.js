const mongoose = require('mongoose');

const ordonnancesSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true },
  provider:{type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false },
  médicament: { type: String, required: true, minlength: 3 },
  dosage: { type: String, required: true, enum: ['1 pill', '2 pills', '1 tablet', '2 tablets', '1 capsule', '2 capsules'] },
  fréquence: { type: String, required: true, enum: ['daily', 'twice per day', 'every 6 hours'] },
  dateDébut: {
    type: Date, required: true, validate: {
      validator: function (v) {
        return v < this.dateFin;
      },
      message: 'La date de début doit être antérieure à la date de fin.'
    }
  },
  dateFin: { type: Date, required: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

ordonnancesSchema.pre('save', function (next) {
  this.updatedAt = new Date();
  next();
});

const Prescription = mongoose.model('Prescription', ordonnancesSchema);

module.exports = Prescription;
