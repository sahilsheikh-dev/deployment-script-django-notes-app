#!/bin/bash

<<task
This script is to deploy django application on docker-compose

1. Clone or Pull the repository
2. Install docker, docker-compose, and nginx packages
3. Check and Start the services
4. Build the image and run it
task

dirname=django-notes-app
giturl=https://github.com/sahilsheikh-dev/django-notes-app.git

code_clone() {
	echo "========================================================="
		echo "******************CLONING DJANGO APP******************"
		git clone $giturl
	cd $dirname
}

code_pull() {
	echo "========================================================="
	echo "******************REPOSITORY ALREADY CLONED, PULLING LATEST REPOSITORY FROM GIT******************"
	cd $dirname
	git pull origin main
}

install_requirements() {
	echo "========================================================="
	echo "******************INSTALLING REQUIRED PACKAGES******************"
	
	sudo yum update -y
	sudo yum install docker -y
	docker --version
	
	echo "---------------------------------------------------------"
	
	if [ -f /usr/local/bin/docker-compose ]; then
		echo "******************DOCKER-COMPOSE PACKAGE ALREADY EXISTS******************"
	else
		sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	fi
	docker-compose --version
	
	echo "---------------------------------------------------------"
	sudo yum install nginx -y
	nginx -version
}

required_restart() {
	echo "========================================================="
	echo "******************SERVICES CHECK AND START******************"
	sudo chown $USER /var/run/docker.sock
	#sudo systemctl start docker
	#sudo systemctl enable docker
	#sudo systemctl enable nginx
}

deoply() {
	echo "========================================================="
	echo "******************DEPLOYING APP TO DOCKER******************"
	docker build -t notes-app .
	echo "---------------------------------------------------------"
	#docker run -d -p 8000:8000 notes-app:latest
	echo "---------------------------------------------------------"
	docker-compose up -d
}

echo "******************DEPLOYMENT STARTED******************"

if [ -d $dirname ]
then
	code_pull	# pull git repo
else
	code_clone	# clone git relo
fi

if ! install_requirements
then
	echo "******************PACKAGES INSTALLATION FAILED******************"
	exit 1
fi

if ! required_restart
then
	echo "******************SYSTEM FAULT OCCURED******************"
	exit 1
fi

if ! deoply
then
	echo "******************DEPLOYMENT FAILED******************"
	exit 1
fi

echo "******************DEPLOYMENT COMPLETED******************"
