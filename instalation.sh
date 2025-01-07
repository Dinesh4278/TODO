#!/bin/bash

# Update the system
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y

# Start Docker service
sudo service docker start

# Add the ec2-user to the Docker group to avoid using sudo for docker commands
sudo usermod -a -G docker ec2-user

# Enable Docker service to start on boot
sudo systemctl enable docker

# Install Docker Compose
DOCKER_COMPOSE_VERSION="1.29.2"  # Specify the version you need
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Set execute permissions for Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
