import express from 'express';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors({ origin: "*" }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on port ${port}`));

let entries = [];
let currentId = 1;

app.get('/', (req, res) => {
  return res.json("hello, world")
});

app.post('/entries', (req, res) => {
  const { a, b, color } = req.body;
  const newEntry = { id: currentId++, a, b, color };
  entries.push(newEntry);
  res.status(201).json(newEntry);
});

app.get('/entries', (req, res) => {
  res.json(entries);
});

app.get('/entries/:filter', (req, res) => {
  const filter = req.params.filter;
  const filteredEntries = entries.filter(entry => entry.a.includes(filter) || entry.b.includes(filter));
  res.json(filteredEntries);
});

app.put('/entries/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const entry = entries.filter(entry => entry.id == id)[0];
  if (entry) {
    entry.b = req.body.b;
    entry.a = req.body.a;
    entry.color = req.body.color;
    res.status(200).json(entry);
  } else {
    res.status(404).end();
  }
});

app.delete('/entries/:id', (req, res) => {
  const id = parseInt(req.params.id);
  entries = entries.filter(entry => entry.id !== id);
  res.status(204).end();
});

app.delete('/entries', (req, res) => {
  entries.length = 0;
  res.status(204).end();
});
