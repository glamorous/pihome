PiHome
============
Docker compose repo for home server based on a raspberry Pi with a couple of handy services.
Included services:
- [Heimdall](https://github.com/linuxserver/Heimdall) (Application dashboard and launcher)
- [Pi-hole](https://pi-hole.net) (A black hole for Internet advertisements)
- [Homeassistant](https://www.home-assistant.io) (Open source home automation that puts local control and privacy first. )

## Prerequisites

### 1. Install Raspbian Lite
Install Raspbian Lite on the SD-card/SSD-drive through [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

Edit `/boot/config.txt` and add this line:

	gpu_mem=16

### 2. Boot up your device
After booting your device, run the basic updates/upgrades:

	sudo apt-get update
	sudo apt-get upgrade

### 3. Install Docker
Start the Docker installer

	curl -sSL https://get.docker.com | sh

Set Docker to auto-start

	sudo systemctl enable docker

### 4. Enable Docker client
The Docker client can only be used by root or members of the docker group. Add pi or your equivalent user to the docker group:

	sudo usermod -aG docker pihome

### 5. Install Portainer
Install portainer volume

	docker volume create portainer_data

Install portainer

	docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

## Install containers through portainer

1. Go to your portainer instance: https://pihome.local:9443
2. Go to stacks
3. Click "Add stack"
   - Add a name "pihome"
   - Choose repository as build method
     - Repository URL: https://github.com/glamorous/pihome
     - Repository reference: refs/head/master
     - GitOps updates: true
     - Fetch interval: 5m
   - Environment variables
       - Upload the stack.env as .env file and adjust where needed
4. Deploy the stack
