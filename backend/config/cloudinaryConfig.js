const cloudinary = require('cloudinary').v2;
require('dotenv').config();

cloudinary.config({
  cloud_name: process.env.dbbdyyluu,
  api_key: process.env.161762684787842,
  api_secret: process.env.6OFgMAWURw4lwjKA-ma8ASHBQic
});

module.exports = cloudinary;
