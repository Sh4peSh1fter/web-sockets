#!/bin/bash

echo "*************************************************************************"
echo "Update yum repositories"
echo "*************************************************************************"

sudo dnf update -y

echo "*************************************************************************"
echo "Install docker and docker compose plugin"
echo "*************************************************************************"

sudo dnf install -y libcgroup-tools

# Install using the rpm repository 
sudo dnf config-manager --add-repo=https://download.docker.com/linux/rhel/docker-ce.repo #https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # --allowerasing
# sudo dnf install -y --nobest docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # Install using the convenience script
# sudo dnf install -y yum-utils device-mapper-persistent-data lvm2
# sudo dnf install -y slirp4netns fuse-overlayfs
# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker vagrant