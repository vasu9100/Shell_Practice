#!/bin/bash

ID=$(id -u)
WHO=$(whoami)
WORKING_DIR=$(pwd)

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

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

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
validate $? "DOWNLOADED FRONT END CODE"

echo "Changing directory to /usr/share/nginx/html"
cd /usr/share/nginx/html
validate $? "CHANGED DIRECTORY TO /usr/share/nginx/html"

rm -f *
validate $? "Removed"

unzip /tmp/web.zip
validate $? "UNZIP"
