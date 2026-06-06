#!/bin/bash
set -eux

# Install Docker, build the image (if files present), and run the container
apt-get update -y
apt-get install -y docker.io
systemctl enable --now docker

# Add ubuntu user to docker group if present
if id ubuntu >/dev/null 2>&1; then
  usermod -aG docker ubuntu || true
fi

APP_DIR=/home/ubuntu/url-shortener
mkdir -p "$APP_DIR"
chown ubuntu:ubuntu "$APP_DIR" || true

if [ -f "$APP_DIR/Dockerfile" ]; then
  cd "$APP_DIR"
  docker build -t url-shortener:latest .
  docker rm -f url-shortener || true
  docker run -d --restart unless-stopped -p 80:3000 --name url-shortener url-shortener:latest
else
  echo "No Dockerfile found in $APP_DIR; nothing to build" >&2
fi

exit 0
