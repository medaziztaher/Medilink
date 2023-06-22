const mongoose = require('mongoose');


const feedbackResponseSchema = new mongoose.Schema({
  feedback: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Feedback',
    required: true,
  },
  response:{
    type:String,
    required:true
  }
});

const FeedbackResponse = mongoose.model('FeedbackResponse', feedbackResponseSchema);

module.exports = FeedbackResponse;
