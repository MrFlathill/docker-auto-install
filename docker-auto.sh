#!/bin/bash
# This script will automatically add the repository of Docker and and install (or remove) all necessary packages.
#
# Supports: Ubuntu 22.04
#
# Please execute this script with NON ROOT user
# Requires Restart after execution
#
#
# By: Maximilian Ebenkofler (Flathill)
#
# Inspired by this Guide: https://docs.docker.com/engine/install/ubuntu/


RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Starting"

# Check if script is started by non root user
if [ "$EUID" -eq 0 ]
  then echo -e "${RED}ERROR:${NC} Please run script with ${BLUE}NON ROOT${NC} user\n"
  echo "exit"
  exit
fi

# Update and upgrade
echo -e "\n${GREEN}Update and upgrade${NC}"
sudo apt update && sudo apt dist-upgrade -y

# Autoremove and clean
echo -e "\n${GREEN}Autoremove and clean${NC}"
sudo apt autoremove -y && sudo apt clean

# Remove previouse Docker installations
echo -e "\n${GREEN}Fully remove potentiall previouse Docker installations${NC}"
sudo apt remove --purge docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc -y

# Setup Repository
echo -e "\n${GREEN}Setting up Docker repository${NC}"
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker via apt
echo -e "\n${GREEN}Installing Docker from repository trough apt${NC}"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Change permission for local user by adding to "docker" group
user=$(whoami)
echo -e "\n${GREEN}Adding ${BLUE}$user${GREEN} to group ${BLUE}docker${NC}"
sudo gpasswd -a "$user" docker
