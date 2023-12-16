#!/bin/bash

ID=$(id -u)
WHO=$(whoami)
WORKING_DIR=$(pwd)

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
NGINX_STATUS=$(rpm -q nginx)

validate(){
    
    if [ $1 -ne 0 ]; then

        echo -e "$2 ....${RED} FAILED"
    else

        echo -e "$2 ....${GREEN} SUCCES"

    fi    
}

if [ $ID -ne 0 ]; then

    echo -e "${RED} PERMISSION DENIED ${ENDCOLOR} BECAUSE OF ${RED} ${WHO} ${ENDCOLOR} AND YOUR PRESENT WORKING DIRECTORY IS ${RED} ${WORKING_DIR}"
    exit 1

else

    echo -e  "${GREEN} PREMSSION GRANTED ${ENDCOLOR} BECA USE YOUR ${GREEN} ${WHO} ${ENDCOLOR} USER"

fi

if [ -n ${NGINX_STATUS} ]; then
    echo "NGINX ALREADY INSTALLED, SO SKIPPING INSTALLATION"
    exit 1
else
    yum install nginx -y
    validate $? "NGINX INSTALLATION"
fi
   

