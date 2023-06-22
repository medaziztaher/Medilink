const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  healthcareProvider: { type: mongoose.Schema.Types.ObjectId, ref: 'HealthcareProvider' },
  rating: Number,
  review: Number,
});

const Reviews = mongoose.model('Reviews', reviewSchema);

module.exports = Reviews;
