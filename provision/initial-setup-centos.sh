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