const mongoose = require('mongoose');

const symptomSchema = new mongoose.Schema({
    nom : {
        type : String ,
        required : true
    },
    date:{type:Date,default: Date.now}
})

const Symptom = mongoose.model('Symptom', symptomSchema);

module.exports = Symptom;
