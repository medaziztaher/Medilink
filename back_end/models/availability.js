const mongoose = require('mongoose');

const availabilitySchema = new mongoose.Schema({
    provider: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    day: { type: String, required: true },
    start: { type: String, required: true },
    end: { type: String, required: true },
});

const Availability = mongoose.model('Availability', availabilitySchema);

module.exports = Availability;
