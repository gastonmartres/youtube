#!/bin/bash
sudo dnf -y --refresh update

sudo dnf -y upgrade

sudo dnf install -y yum-utils
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl start docker

sudo systemctl enable docker