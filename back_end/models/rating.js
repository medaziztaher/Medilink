const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
  healthcareProvider: { type: mongoose.Schema.Types.ObjectId, ref: 'HealthcareProvider' },
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient' },
  rating: { type: Number, required: true },
  review: String,
});

const Rating = mongoose.model('Rating', ratingSchema);

module.exports = Rating;
