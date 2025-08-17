#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update -yq
apt-get install -yq git python3-venv python3-pip build-essential pkg-config python3-dev
apt-get install -yq default-libmysqlclient-dev || apt-get install -yq libmysqlclient-dev || apt-get install -yq libmariadb-dev

# чистий venv щоразу
rm -rf /opt/app-venv
python3 -m venv /opt/app-venv
source /opt/app-venv/bin/activate
pip install --upgrade pip setuptools wheel

# код
TMP="/tmp/devops-app"
rm -rf "$TMP"
git clone --depth 1 --branch develop https://github.com/Alex13-th/DevOps-App "$TMP"
mkdir -p /app && rm -rf /app/* || true
cp -r "$TMP/src/"* /app/

# залежності
[ -f /app/requirements.txt ] && pip install -r /app/requirements.txt
pip install gunicorn

# django підготовка
[ -f /app/manage.py ] && python /app/manage.py migrate --noinput || true
[ -f /app/manage.py ] && python /app/manage.py collectstatic --noinput || true
[ -f /app/todolist/settings.py ] && sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = ['*']/" /app/todolist/settings.py || true

# systemd unit
cat >/etc/systemd/system/todoapp.service <<'EOF'
[Unit]
Description=todoapp (gunicorn)
After=network-online.target

[Service]
WorkingDirectory=/app
Environment=PATH=/opt/app-venv/bin
ExecStart=/opt/app-venv/bin/gunicorn todolist.wsgi:application --bind 0.0.0.0:8080 --workers 2 --timeout 60
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now todoapp || true
echo "✅ Deployed on gunicorn :8080"