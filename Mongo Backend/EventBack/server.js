const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

// Middleware
app.use(bodyParser.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/eventDB', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('MongoDB connection error:', err));



// Event Schema
const eventSchema = new mongoose.Schema({
  poster: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  address: { type: String, required: true },
  state: { type: String, required: true },
  country: { type: String, required: true },
  category: { type: String, required: true },
  tickets: { type: Number, required: true },
  sold: { type: Number, default: 0 },
  refunded: { type: Number, default: 0 },
  timestamp: { type: String, required: true },
  start: { type: String, required: true },
  end: { type: String, required: true },
  price: { type: Number, required: true },
  rating: { type: Number, required: true }
});

const Event = mongoose.model('Event', eventSchema);

// Routes
// Create Event
app.post('/api/events', async (req, res) => {
  try {
    const eventData = req.body;
    const newEvent = new Event(eventData);
    const savedEvent = await newEvent.save();
    res.status(201).json(savedEvent);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});





const userSchema = new mongoose.Schema({
  _id: Number,
  age: Number,
  state: String,
  country: String,
  pincode: Number,
  buyTime: Number,
  category: String,
  amount: Number,
  payMethod: String,
  prevHistory: Number,
  source: String,
  refund:Boolean,
  updated:Boolean,
  eventId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Event' // References the Event model
  },
});

const Customer = mongoose.model("Customer", userSchema);

app.patch('/api/sync-events', async (req, res) => {
  try {
    const users = await Customer.find({});

    for (const user of users) {
      const event = await Event.findById(user.eventId);
      console.log(event);
      if (event) {
        // Optional: Skip if tickets are sold out
        if (event.tickets > 0   &&  user.refund===false   &&  user.updated===false) {
          event.tickets -= 1;
          event.sold += 1;
          user.updated=true;
          await event.save();
          console.log(`✅ Updated event ${event._id} for user ${user._id}`);
        } else {
          console.log(`⚠ No tickets left for event ${event._id}`);
        }
      } else {
        console.log(`❌ Event not found for user ${user._id}`);
      }
    }

    res.status(200).json({ message: "Event sync completed successfully." });
  } catch (err) {
    console.error("Error syncing events:", err);
    res.status(500).json({ message: "Server error during sync." });
  }
});





app.get('/api/customers', async (req, res) => {
  const users = [];
  for (let i = 1; i <= 10; i++) {
      const customer = await Customer.findById(i);
      users.push(customer);
  }
  return res.status(201).json({users:users})
});


// // Get All Events
app.get('/api/events', async (req, res) => {
  try {
    const events = await Event.find();
    res.json(events);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get Single Event
app.get('/api/events/:id', async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) {
      return res.status(404).json({ message: 'Event not found' });
    }
    res.json(event);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update Event
app.put('/api/events/:id', async (req, res) => {
  try {
    const updatedEvent = await Event.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedEvent) {
      return res.status(404).json({ message: 'Event not found' });
    }
    res.json(updatedEvent);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete Event
app.delete('/api/events/:id', async (req, res) => {
  try {
    const deletedEvent = await Event.findByIdAndDelete(req.params.id);
    if (!deletedEvent) {
      return res.status(404).json({ message: 'Event not found' });
    }
    res.json({ message: 'Event deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

const PORT = process.env.PORT || 4500;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});