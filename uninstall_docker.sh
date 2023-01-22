#!/bin/bash

echo "Uninstalling Docker...."
echo ""

if [ -e /usr/bin/docker ] && [ -e /var/lib/docker ]
then
   sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin docker-compose
   sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin docker-compose
   sudo rm -rf /var/lib/docker /etc/docker
   sudo groupdel docker
   sudo rm -rf /var/run/docker.sock
   sudo rm -rf /etc/apt/keyrings/docker.gpg
   echo ""
   echo "docker has been completely uninstalled...."
else
   echo "docker is not installed...."
fi
