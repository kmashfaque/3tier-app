#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>3-Tier AWS Terraform App</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f5f7fb; color: #1f2937; padding: 32px; }
    .container { max-width: 760px; margin: 0 auto; background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 20px 60px rgba(15, 23, 42, 0.08); }
    button { background: #2563eb; color: white; border: none; padding: 12px 22px; border-radius: 8px; cursor: pointer; }
    pre { background: #eef2ff; padding: 16px; border-radius: 8px; }
  </style>
</head>
<body>
  <div class="container">
    <h1>3-Tier AWS Terraform App</h1>
    <p>This demo is deployed using Terraform on AWS with Nginx, Node.js, and RDS.</p>
    <button onclick="fetchData()">Call Backend API</button>
    <pre id="result">Response will appear here...</pre>
  </div>
  <script src="/app.js"></script>
</body>
</html>
EOF

cat > /var/www/html/app.js <<'EOF'
async function fetchData() {
  const result = document.getElementById('result');
  result.textContent = 'Connecting to backend...';

  try {
    const response = await fetch('/api/health');
    const data = await response.json();
    result.textContent = JSON.stringify(data, null, 2);
  } catch (error) {
    result.textContent = 'Backend request failed: ' + error;
  }
}
EOF

cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /api {
        proxy_pass http://${app_private_ip}:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

systemctl restart nginx
