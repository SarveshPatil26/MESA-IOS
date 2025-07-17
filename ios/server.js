require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => console.log("MongoDB Connected"))
  .catch(err => console.error("MongoDB Connection Error:", err));

// Schema & Model
const fileSchema = new mongoose.Schema({
    subject: String,
    fileURL: String,
    uploadedAt: { type: Date, default: Date.now }
});

const File = mongoose.model('File', fileSchema);

// Route to Save File Link
app.post('/upload', async (req, res) => {
    try {
        const { subject, fileURL } = req.body;
        if (!subject || !fileURL) {
            return res.status(400).json({ message: "Missing subject or file URL" });
        }

        const newFile = new File({ subject, fileURL });
        await newFile.save();
        res.status(201).json({ message: "File stored in MongoDB", file: newFile });
    } catch (err) {
        res.status(500).json({ message: "Server Error", error: err.message });
    }
});

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

