const mongoose = require('mongoose');


const feedbackSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  rating: {
    type: Number,
    required: false,
    min: 1,
    max: 5,
  },
  comment: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    default: Date.now,
  },
  files :[{
    id:String,
    url:String
  }],
  response:{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'FeedbackResponse',
  }
});

const Feedback = mongoose.model('Feedback', feedbackSchema);

module.exports = Feedback;
