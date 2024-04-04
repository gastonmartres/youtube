#!/bin/bash
sudo dnf -y --refresh update

sudo dnf -y upgrade
sudo dnf install -y epel-release
sudo dnf install -y yum-utils git vim tar zip unzip open-vm-tools screen qemu-guest-agent
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl start docker

sudo systemctl enable docker