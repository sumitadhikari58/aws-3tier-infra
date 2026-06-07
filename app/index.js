const express = require("express");
const app = express();
const urlMap = {};
app.use(express.json());
const longUrl = req.body.url;
const shortCode = Math.random().toString(36).substring(2, 8);
urlMap[shortCode] = longUrl;

app.get('/health', (req, res) => {
  res.json({ status: "ok" });
});

app.listen(80, () => {
  console.log("Listening on 80");
});
