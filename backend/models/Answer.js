const mongoose = require('mongoose');

const answerSchema = new mongoose.Schema({
  fileURL: String,
  subject: String,
  uploadedAt: Number
});

module.exports = mongoose.model('Answer', answerSchema);
