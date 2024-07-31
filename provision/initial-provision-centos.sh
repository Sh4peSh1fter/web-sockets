#!/bin/bash

echo "*************************************************************************"
echo "Update yum repositories"
echo "*************************************************************************"

sudo dnf update -y

echo "*************************************************************************"
echo "Install docker and docker compose plugin"
echo "*************************************************************************"

# Install using the rpm repository 
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # --allowerasing
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant

echo "*************************************************************************"
echo "Generate self-signed certificates"
echo "*************************************************************************"

mkdir -p /home/vagrant/apps/certs
sudo chown vagrant:vagrant /home/vagrant/apps/certs
openssl req -x509 -newkey rsa:4096 -keyout /home/vagrant/apps/certs/server.key -out /home/vagrant/apps/certs/server.crt -days 365 -nodes -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

echo "*************************************************************************"
echo "docker compose up"
echo "*************************************************************************"

sudo su - vagrant -c "docker compose -f /home/vagrant/apps/docker-compose.yaml up -d --build"