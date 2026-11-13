const { solarSystems, dashboardSummary } = require('../data/solarData');

exports.getSolarSystems = (req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ success: true, count: solarSystems.length, data: solarSystems }));
};

exports.getSolarSystemById = (req, res, id) => {
  const system = solarSystems.find((s) => s.id === id);
  if (system) {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ success: true, data: system }));
  } else {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ success: false, message: 'Solar system not found' }));
  }
};

exports.getDashboardSummary = (req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ success: true, data: dashboardSummary }));
};
