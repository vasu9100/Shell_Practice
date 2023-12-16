#!/bin/bash

ID=$(id -u)
WHO=$(whoami)
WORKING_DIR=$(pwd)
DATE=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/tmp/$0-${DATE}.log"

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
YELLOW="\e[33m"

print_color() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${ENDCOLOR}"
}

validate() {
    if [ $1 -ne 0 ]; then
        print_color "${RED}" "$2 .... FAILED"
        exit 1
    else
        print_color "${GREEN}" "$2 .... SUCCESS"
    fi
}

print_color "${GREEN}" "Checking permissions..."

if [ $ID -ne 0 ]; then
    print_color "${RED}" "PERMISSION DENIED because of ${WHO}. Your present working directory is ${WORKING_DIR}"
    exit 1
else
    print_color "${GREEN}" "PERMISSION GRANTED for ${WHO} user"
fi

dnf list installed | grep -q "nginx"
validate $? "CHECKING NGINX STATUS"

if [ $? -eq 0 ]; then
    print_color "${GREEN}" "NGINX already installed, so skipping installation."
else
    yum install nginx -y
    validate $? "NGINX INSTALLATION"
fi

systemctl enable nginx
validate $? "NGINX ENABLED"

systemctl start nginx
validate $? "NGINX START"

if [ ! -e /tmp/web.zip ]; then
    curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
    validate $? "DOWNLOADED FRONT END CODE"
fi

print_color "${YELLOW}" "Changing directory to /usr/share/nginx/html"
cd /usr/share/nginx/html
validate $? "CHANGED DIRECTORY TO /usr/share/nginx/html"

rm -rf *.html *.css *.js
validate $? "Removed"

if [ -e /tmp/web.zip ]; then
    print_color "${GREEN}" "web.zip already existed, so unzipping."
    unzip -o /tmp/web.zip &>>${LOG_FILE}
    validate $? "UNZIP"
else
    print_color "${RED}" "web.zip file already existed, so no need to install."
fi

cd /home/centos/Shell_Practice
validate $? "CHANGING DIRECTORY TO /home/centos/Shell_Practice"

if [ ! -e /home/centos/Shell_Practice/roboshop.conf ]; then
    print_color "${YELLOW}" "File exists. Start copying..."
fi

if [ -e /home/centos/Shell_Practice/roboshop.conf ]; then
    print_color "${GREEN}" "Started copying into destination."
    cp -f roboshop.conf /etc/nginx/default.d/
    validate $? "Copied roboshop.conf"
fi

systemctl restart nginx
validate $? "NGINX RESTARTED"
