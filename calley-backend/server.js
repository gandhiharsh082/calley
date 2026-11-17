// Calley mock API - same endpoints and response shapes as "Mock API V2".
// Data is kept in memory (resets when the server restarts).
const express = require('express');
const cors = require('cors');
const crypto = require('crypto');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
// No email provider is connected, so the OTP is returned in the response.
// Set SHOW_OTP=false if you add real email sending.
const SHOW_OTP = process.env.SHOW_OTP !== 'false';

// ---------- helpers ----------
const newId = () => crypto.randomBytes(12).toString('hex'); // Mongo-like id
const hash = (password, salt) =>
  crypto.scryptSync(password, salt, 32).toString('hex');
const isEmail = (v) => typeof v === 'string' && /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v);

const FIRST = ['Danielle', 'Rahul', 'Priya', 'Arjun', 'Sara', 'Vikram', 'Neha', 'Karan', 'Anita', 'Rohit','Saurab'];
const LAST = ['Johnson', 'Sharma', 'Nair', 'Mehta', 'Khan', 'Reddy', 'Gupta', 'Iyer', 'Das', 'Patel'];
const TITLES = ['Mrs.', 'Mr.', 'Ms.', 'Dr.'];

// 61 calls: 27 pending, 23 called, 11 rescheduled (same counts as the docs).
function buildCalls() {
  const statuses = [
    ...Array(27).fill('pending'),
    ...Array(23).fill('called'),
    ...Array(11).fill('rescheduled'),
  ];
  return statuses.map((status, i) => ({
    FirstName: FIRST[i % FIRST.length],
    LastName: LAST[(i * 3) % LAST.length],
    Title: TITLES[i % TITLES.length],
    Phone: 1000000000 + i * 3,
    'Other Phone 1': 1000000003 + i * 3,
    status,
  }));
}

// ---------- in-memory store ----------
const users = []; // {_id, username, email, salt, passwordHash, verified}
const lists = []; // {_id, name, agents, clientId, calls}
const otps = new Map(); // email -> otp

function createUser({ _id, username, email, password, verified }) {
  const salt = crypto.randomBytes(8).toString('hex');
  const user = {
    _id: _id || newId(),
    username,
    email: email.toLowerCase(),
    salt,
    passwordHash: hash(password, salt),
    verified: !!verified,
  };
  users.push(user);
  lists.push({
    _id: newId(),
    name: 'Test List',
    agents: [],
    clientId: user._id,
    calls: buildCalls(),
  });
  return user;
}

// Demo account from the docs, ready to log in.
createUser({
  _id: '68626f9497757cb741f449b0',
  username: 'Dhrubo',
  email: 'dhrubo@yopmail.com',
  password: '123',
  verified: true,
});

const publicUser = (u) => ({ _id: u._id, username: u.username, email: u.email });
const findByEmail = (email) =>
  users.find((u) => u.email === String(email || '').toLowerCase());

// ---------- health ----------
app.get('/', (req, res) => res.json({ message: 'Calley mock API is running' }));

// ---------- auth ----------
app.post('/api/auth/register', (req, res) => {
  const { username, email, password } = req.body || {};
  if (!username || !isEmail(email) || !password) {
    return res.status(400).json({ message: 'username, valid email and password are required' });
  }
  if (findByEmail(email)) {
    return res.status(409).json({ message: 'User already exists' });
  }
  createUser({ username, email, password, verified: false });
  res.status(201).json({ message: 'User registered' });
});

app.post('/api/auth/send-otp', (req, res) => {
  const { email } = req.body || {};
  if (!findByEmail(email)) return res.status(404).json({ message: 'User not found' });
  const otp = String(Math.floor(100000 + Math.random() * 900000));
  otps.set(email.toLowerCase(), otp);
  console.log(`OTP for ${email}: ${otp}`);
  const body = { message: 'OTP sent' };
  if (SHOW_OTP) body.otp = otp;
  res.json(body);
});

app.post('/api/auth/verify-otp', (req, res) => {
  const { email, otp } = req.body || {};
  const user = findByEmail(email);
  if (!user) return res.status(404).json({ message: 'User not found' });
  if (!otps.has(user.email) || otps.get(user.email) !== String(otp)) {
    return res.status(400).json({ message: 'Invalid OTP' });
  }
  otps.delete(user.email);
  user.verified = true;
  res.json({ message: 'OTP Verified' });
});

app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = findByEmail(email);
  if (!user || hash(String(password || ''), user.salt) !== user.passwordHash) {
    return res.status(401).json({ message: 'Invalid email or password' });
  }
  if (!user.verified) {
    return res.status(403).json({ message: 'Please verify your OTP first' });
  }
  res.json({ message: 'Login successful', user: publicUser(user) });
});

// ---------- lists ----------
app.get('/api/list', (req, res) => {
  const { userId } = req.query;
  if (!userId) return res.status(400).json({ message: 'userId is required' });
  const result = lists
    .filter((l) => l.clientId === userId)
    .map(({ _id, name, agents, clientId }) => ({ _id, name, agents, clientId }));
  res.json(result);
});

app.get('/api/list/:id', (req, res) => {
  const list = lists.find((l) => l._id === req.params.id);
  if (!list) return res.status(404).json({ message: 'List not found' });
  const count = (s) => list.calls.filter((c) => c.status === s).length;
  res.json({
    pending: count('pending'),
    called: count('called'),
    rescheduled: count('rescheduled'),
    calls: list.calls,
  });
});

// JSON 404 so the app always gets a readable message
app.use((req, res) => res.status(404).json({ message: 'Route not found' }));

app.listen(PORT, () => console.log(`Calley mock API listening on port ${PORT}`));
