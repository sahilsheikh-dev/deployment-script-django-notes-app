#!/bin/bash

<<task
this script is to deploy django application
task

dirname=django-notes-app
giturl=https://github.com/sahilsheikh-dev/django-notes-app.git

code_clone() {
	echo "========================================================="
        echo "Cloning DJango App"
        git clone $giturl
	cd $dirname
}
code_pull() {
	echo "========================================================="
	echo "Already Cloned, Pulling latest repo from git"
	cd $dirname
	git pull origin main
}

install_requirements() {
	echo "========================================================="
	echo "Installing required packages"
	
	sudo yum update -y
	sudo yum install docker -y
	docker --version
	echo "---------------------------------------------------------"
	sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version
	echo "---------------------------------------------------------"
	sudo yum install nginx -y
	nginx -version
}

required_restart() {
	echo "========================================================="
	echo "Starting services"
        sudo chown $USER /var/run/docker.sock
	#sudo systemctl start docker
	#sudo systemctl enable docker
	#sudo systemctl enable nginx
}

deoply() {
	echo "========================================================="
	echo "Deploying app to docker"
        docker build -t notes-app .
        echo "---------------------------------------------------------"
	#docker run -d -p 8000:8000 notes-app:latest
	echo "---------------------------------------------------------"
	docker-compose up -d
}

echo "******************DEPLOYMENT STARTED*******************"

if [ -d $dirname ]
then
	code_pull	# pull git repo
else
	code_clone	# clone git relo
fi

if ! install_requirements
then
	echo "Installation Failed"
	exit 1
fi

if ! required_restart
then
	echo "System Fault Occured"
	exit 1
fi

if ! deoply
then
	echo "Failed Deployment"
	exit 1
fi

echo "******************DEPLOYMENT COMPLETED*******************"

