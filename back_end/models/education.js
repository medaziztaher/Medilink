const mongoose = require('mongoose');

const educationSchema = new mongoose.Schema({
    provider: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    degree: {
        type: String,
        required: true,
    },
    institution: {
        type: String,
        required: true,
    },
    startYear: {
        type: String,
        required: true,
    },
    endYear: {
        type: String,
        required: false,
    },
    file:[{
        type :String,
        id:String,
        url:String
    }],
});

const Education = mongoose.model('Education', educationSchema);

module.exports = Education;
