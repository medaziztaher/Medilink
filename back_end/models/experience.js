const mongoose = require('mongoose');

const experienceSchema = new mongoose.Schema({
    provider: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    position: {
        type: String,
        required: true,
    },
    institution: {
        type: String,
        required: true,
    },
    startYear: {
        type: Number,
        required: false,
    },
    endYear: {
        type: Number,
    },
    file: [{
        type:String,
        id:String,
        url: String
    }],
});

const Experience = mongoose.model('Experience', experienceSchema);

module.exports = Experience;
