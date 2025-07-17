const express = require('express');
const Answer = require('../models/Answer');
const cloudinary = require('../config/cloudinaryConfig');
const upload = require('../middleware/uploadMiddleware');

const router = express.Router();

router.post('/upload', upload.single('file'), async (req, res) => {
  try {
    const { subject } = req.body;
    
    cloudinary.uploader.upload_stream({ resource_type: "auto" }, async (error, result) => {
      if (error) return res.status(500).json({ error: error.message });

      const answer = new Answer({ fileURL: result.secure_url, subject, uploadedAt: Date.now() });
      await answer.save();
      res.status(201).json({ message: 'File uploaded successfully', fileURL: result.secure_url });
    }).end(req.file.buffer);
    
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/files', async (req, res) => {
  const files = await Answer.find();
  res.json(files);
});

module.exports = router;
