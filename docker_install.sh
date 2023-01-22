#!/bin/bash

sudo apt update && sudo apt upgrade -y

if [ -e /usr/bin/docker ]
then
   echo "docker is installed in the system..."
else
   echo "docker is not installed...."
   echo ""
   echo ""
   DOCKER="yes"
   if [ $DOCKER == 'yes' ] || [ $DOCKER == 'y' ]
   then
      echo "installing docker..."
      echo ""
      echo ""
      
      sudo apt-get update && \
      sudo apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

      echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update

      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y
      sudo systemctl restart docker
      status=$(systemctl status docker | grep -i "active" | awk '{print $2}')
      while [ $status == "failed" ]
      do
        sudo /etc/init.d/docker start
        sudo systemctl enable docker
      done
        sudo usermod -aG docker $USER
   else
	echo "exiting..."
        exit
   fi
fi   
