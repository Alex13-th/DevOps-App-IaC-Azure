#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# APT hardening (Jammy hook fix + чистий кеш)
sudo rm -rf /var/lib/apt/lists/* || true
sudo mkdir -p /var/lib/apt/lists/partial || true

# update без post-invoke хуків
sudo apt-get update \
  -o Acquire::Retries=3 \
  -o APT::Update::Post-Invoke-Success::= \
  -o APT::Update::Post-Invoke::=

# install також без конфліктних хуків
sudo apt-get install -yq \
  -o Dpkg::Options::=--force-confnew \
  -o Dpkg::Options::=--force-confdef \
  git python3-venv python3-pip build-essential pkg-config python3-dev

sudo apt-get install -yq \
  -o Dpkg::Options::=--force-confnew \
  -o Dpkg::Options::=--force-confdef \
  default-libmysqlclient-dev || \
sudo apt-get install -yq libmysqlclient-dev || \
sudo apt-get install -yq libmariadb-dev

# чистий venv щоразу
sudo rm -rf /opt/app-venv
python3 -m venv /opt/app-venv
source /opt/app-venv/bin/activate
pip install --upgrade pip setuptools wheel

# код
TMP="/tmp/devops-app"
rm -rf "$TMP"
git clone --depth 1 --branch develop https://github.com/Alex13-th/DevOps-App "$TMP"
sudo mkdir -p /app && sudo rm -rf /app/* || true
sudo cp -r "$TMP/src/"* /app/

# залежності
[ -f /app/requirements.txt ] && pip install -r /app/requirements.txt
pip install gunicorn

# django підготовка
[ -f /app/manage.py ] && python /app/manage.py migrate --noinput || true
[ -f /app/manage.py ] && python /app/manage.py collectstatic --noinput || true
[ -f /app/todolist/settings.py ] && sudo sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = ['*']/" /app/todolist/settings.py || true

# systemd unit
sudo tee /etc/systemd/system/todoapp.service >/dev/null <<'EOF'
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

sudo systemctl daemon-reload
sudo systemctl enable --now todoapp || true
echo "✅ Deployed on gunicorn :8080"
