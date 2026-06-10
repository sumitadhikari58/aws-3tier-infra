const express = require("express");
const app = express();
const urlMap = {};
app.use(express.json());
app.post('/shorten',(req,res)=>{
const longUrl = req.body.url;
const shortCode = Math.random().toString(36).substring(2, 8);
urlMap[shortCode] = longUrl;
res.json({ shortCode: shortCode });
});
app.get('/health', (req, res) => {
  res.json({ status: "ok" });
});
app.get('/:code', (req, res) => {
  let { code } = req.params;
  let orgurl = urlMap[code];
  if (orgurl) {
    res.redirect(orgurl);
  } else {
    res.status(404).json({ error: "url not found" });
  }
});

app.listen(80, () => {
  console.log("Listening on 80");
});