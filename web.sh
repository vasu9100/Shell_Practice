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


validate(){
    
    if [ $1 -ne 0 ]; then

        echo -e "$2 ....${RED} FAILED ${ENDCOLOR}"
        exit 1
    else

        echo -e "$2 ....${GREEN} SUCCESS ${ENDCOLOR}"

    fi    
}

if [ $ID -ne 0 ]; then

    echo -e "${RED}PERMISSION DENIED ${ENDCOLOR} BECAUSE OF ${RED} ${WHO} ${ENDCOLOR} AND YOUR PRESENT WORKING DIRECTORY IS ${RED} ${WORKING_DIR}"
    exit 1

else

    echo -e  "${GREEN}PREMSSION GRANTED ${ENDCOLOR} BECAUSE YOUR ${GREEN} ${WHO} ${ENDCOLOR} USER"

fi

dnf list installed | grep -q "nginx" 
validate $? "CHECKING NGINX STATUS"

if [ $? -eq 0 ]; then
    echo -e "NGINX ALREADY ${GREEN} INSTALLED ${ENDCOLOR}, SO SKIPPING INSTALLATION"
else
    yum install nginx -y
    validate $? "NGINX INSTALLATION"
fi
   
systemctl enable nginx
validate $? "NGINX ENABLED"

systemctl start nginx
validate $? "NGINX START"

#find /tmp/ -name "web.zip"
#validate $? "Web.zip Verification"

if [ ! -e /tmp/web.zip ]; then

    curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
    validate $? "DOWNLOADED FRONT END CODE"
fi

echo "Changing directory to /usr/share/nginx/html"

cd /usr/share/nginx/html

validate $? "CHANGED DIRECTORY TO /usr/share/nginx/html"

rm -rf *.html *.css *.js

validate $? "Removed"

if [ -e /tmp/web.zip ]; then
    echo "web.zp Already existed so unzipping"
    unzip -o /tmp/web.zip &>>${LOG_FILE}
    validate $? "UNZIP"
else    

   echo "${RED} web.zip file already existed so no need to install ${ENDCOLOR}"
fi

cd /home/centos/Shell_Practice
validate $? "CHANGING DIRETORY TO ::/home/centos/Shell_Practice::"

#find /home/centos/Shell_Practice -name "roboshop.conf"

if [ ! -e /home/centos/Shell_Practice/roboshop.conf ]; then

    echo "File is existed start to copying"
fi

if [ -e /home/centos/Shell_Practice/roboshop.conf ]; then
  
    echo "Started copying into destination"
    cp -f roboshop.conf /etc/nginx/default.d/
    validate $? "Copied roboshop.conf"
fi 
systemctl restart nginx
validate $? "NGINX RESTARTED"