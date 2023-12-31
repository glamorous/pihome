PiHome
============
Docker compose repo for home server based on a raspberry Pi with a couple of handy services.
Included services:
- [Heimdall](https://github.com/linuxserver/Heimdall) (Application dashboard and launcher)
- [Pi-hole](https://pi-hole.net) (A black hole for Internet advertisements)
- [Homeassistant](https://www.home-assistant.io) (Open source home automation that puts local control and privacy first. )
- [InfluxDB](https://www.influxdata.com) (Database that stores and queries any type of time series data)

## Prerequisites

### 1. Install Raspbian Lite
Install Raspbian Lite on the SD-card/SSD-drive through [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

Edit `/boot/config.txt` and add this line:

	gpu_mem=16

### 2. Boot up your device and update
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
       - Upload the secrets.env and adjust where needed (only first time, otherwise manual adding)
4. Deploy the stack

## Setting up InfluxDB (first time only!)

1. Go to http://pihome.local:8086 and follow onboarding
2. Choose a username and password
3. Choose "home" as your organisation name
4. Choose "homeassistant" as your bucket name
5. Click "Quick start"

### Create token(s) for applications

Instead of username and password, we need tokens for applications that will use InfluxDB (such as Home assistant)
1. Click "API tokens" on first menu item
2. Click "Generate API token" - "Custom API token"
3. Click a name, for example "homeassistant" and choose the correct rights for the selected bucket
   - Home assistant will need write access!
4. Copy the token so you can add it to your config of the application

#### Configure HomeAssistant for usage with InfluxDB

Open HomeAssistant `configuration.yaml` file and add:

```
influxdb:
  api_version: 2
  ssl: false
  host: localhost
  port: 8086
  token: !secret INFLUXDB_TOKEN
  organization: !secret INFLUXDB_ORG
  bucket: !secret INFLUXDB_BUCKET
```

Open HomeAssistant `secrets.yaml` file and add:

```
INFLUXDB_TOKEN: YOUR_API_TOKEN_FROM_PREVIOUS_STEP
INFLUXDB_ORG: home
INFLUXDB_BUCKET: homeassistant
```
