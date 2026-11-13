const authController = require('./controllers/authController');
const solarController = require('./controllers/solarController');

async function handleRoutes(req, res, body, url) {
  // Auth Routes
  if (req.method === 'POST' && url.pathname === '/api/auth/send-otp') {
    return authController.sendOtp(req, res, body);
  }

  if (req.method === 'POST' && url.pathname === '/api/auth/verify-otp') {
    return authController.verifyOtp(req, res, body);
  }

  // Solar Systems Routes
  if (req.method === 'GET' && url.pathname === '/api/solar-systems') {
    return solarController.getSolarSystems(req, res);
  }

  if (req.method === 'GET' && url.pathname.startsWith('/api/solar-systems/')) {
    const id = url.pathname.split('/')[3];
    return solarController.getSolarSystemById(req, res, id);
  }

  // Dashboard Routes
  if (req.method === 'GET' && url.pathname === '/api/dashboard/summary') {
    return solarController.getDashboardSummary(req, res);
  }

  // 404
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ success: false, message: 'Route not found' }));
}

module.exports = handleRoutes;
