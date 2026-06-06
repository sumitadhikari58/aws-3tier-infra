#!/bin/bash
set -eux

apt-get update -y
apt-get install -y docker.io awscli

systemctl start docker
systemctl enable docker

export AWS_DEFAULT_REGION=ap-south-1

# Login to ECR and pull the image
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 108209429292.dkr.ecr.ap-south-1.amazonaws.com

docker pull 108209429292.dkr.ecr.ap-south-1.amazonaws.com/url-shortener:latest

# Remove any existing container, then run the new one
docker rm -f url-shortener || true
docker run -d --restart unless-stopped -p 80:80 --name url-shortener 108209429292.dkr.ecr.ap-south-1.amazonaws.com/url-shortener:latest

exit 0
