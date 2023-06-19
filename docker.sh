#!/bin/bash

# Checking whether is sudoer or root
DOCKER_VERSION=$(docker --version | cut -d ' ' -f 3 | tr -d ',')
USER_ID=$(id -u)
if [[ $USER_ID -ne 0 ]]
then
   echo "You need to be a root user to install the docker"
   exit
fi
echo "type install to install package and uninstall to uninstall package.."
echo "type version to check current version."
ARGUMENT=$1

if [[ $ARGUMENT == "install" ]]
then
# check whether docker is installed or not
   if [[ -f /usr/bin/docker ]]
   then
      echo "Docker is installed"
      echo "Docker version is: $DOCKER_VERSION"
   else
      echo "Installing Docker.."
      echo
      echo
      #Update the apt package index and install packages to allow apt to use a repository over HTTPS:
      
      sudo apt-get update
      sudo apt-get install ca-certificates curl gnupg -y

      #Add Docker’s official GPG key:
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      #Use the following command to set up the repository:
      echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      #Update the apt package index:
      sudo apt-get update

      echo "Do you want to install latest version or do you want to install specific version:"
      echo ""
      echo "latest"
      echo ""
      echo "available_version"
      read -p "For latest version type 'latest' or type 'available_version': " VERSION
      
      if [[ $VERSION == "latest" ]]
      then
	 echo "Installing latest Version"
	 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	 echo ""
	 echo ""
	 echo "Docker version is: $DOCKER_VERSION"
	 sudo systemctl restart docker.socket
	 sudo usermod -aG docker $USER
      elif [[ $VERSION == "available_version" ]]
      then
	 echo "Available Versions:"
	 echo ""
	 echo ""
	 apt-cache madison docker-ce | awk '{ print $3 }'
	 echo ""
	 echo ""
	 read -p "Copy and paste the version to install: " VERSION_STRING
	 sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin -y
	 sudo systemctl restart docker.socket
	 sudo usermod -aG docker $USER
      else
	 echo "Type latest or available_version"

	      
      fi

   fi

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################

#TO uninstall docker

elif [[ $ARGUMENT == "uninstall" ]]
then
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

elif [[ $ARGUMENT == "version" ]]
then
  echo "Docker version is: $DOCKER_VERSION"

else
   echo "Type install or uninstall or version"

fi



