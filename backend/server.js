require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/mongoConfig');
const uploadRoutes = require('./routes/uploadRoute');

const app = express();
app.use(express.json());
app.use(cors());

connectDB();
app.use('/api', uploadRoutes);

app.listen(3000, () => console.log('Server running on port 3000'));
