const http = require('http');
const { setCorsHeaders, parseJsonBody } = require('./src/middleware/cors');
const handleRoutes = require('./src/routes');

const PORT = process.env.PORT || 3000;

const server = http.createServer(async (req, res) => {
  setCorsHeaders(res);

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = new URL(req.url, `http://${req.headers.host}`);

  let body = {};
  if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
    try {
      body = await parseJsonBody(req);
    } catch (err) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ success: false, message: 'Invalid JSON payload' }));
      return;
    }
  }

  try {
    await handleRoutes(req, res, body, url);
  } catch (err) {
    console.error('Server internal error:', err);
    res.writeHead(500, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ success: false, message: 'Internal server error' }));
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Mierae Solar Backend API running on http://0.0.0.0:${PORT}`);
});
