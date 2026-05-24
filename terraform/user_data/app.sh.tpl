#!/bin/bash
set -e

apt-get update -y
apt-get install -y curl gnupg build-essential
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

mkdir -p /home/ubuntu/backend
cat > /home/ubuntu/backend/package.json <<'EOF'
{
  "name": "3tier-backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "mysql2": "^3.3.1"
  }
}
EOF

cat > /home/ubuntu/backend/server.js <<'EOF'
const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 5,
});

app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 + 1 AS result');
    res.json({
      status: 'OK',
      message: 'Backend is running',
      db_test: rows[0].result,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    res.status(502).json({
      status: 'ERROR',
      message: 'Database connection failed',
      error: error.message,
    });
  }
});

app.get('/api/data', async (req, res) => {
  res.json({
    app: '3-tier backend',
    version: '1.0.0',
    db_host: process.env.DB_HOST,
  });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Backend listening on port ${port}`);
});
EOF

cd /home/ubuntu/backend
npm install

cat > /etc/systemd/system/app.service <<'EOF'
[Unit]
Description=3-Tier Node.js backend service
After=network.target

[Service]
Environment="DB_HOST=${db_endpoint}"
Environment="DB_USER=${db_username}"
Environment="DB_PASS=${db_password}"
Environment="DB_NAME=${db_name}"
WorkingDirectory=/home/ubuntu/backend
ExecStart=/usr/bin/node /home/ubuntu/backend/server.js
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable app
systemctl start app
