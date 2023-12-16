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

        echo "$2 ....${RED} FAILED"
    else

        echo "$2 ....${GREEN}SUCCESS"

    fi    
}

if [ $ID -ne 0 ]; then

    echo -e "${RED} PERMISSION DENIED ${ENDCOLOR} BECAUSE OF ${RED} ${WHO} ${ENDCOLOR} AND YOUR PRESENT WORKING DIRECTORY IS ${RED} ${WORKING_DIR}"
    exit 1

else

    echo -e  "${GREEN} PREMSSION GRANTED ${ENDCOLOR} BECAUSE YOUR ${GREEN} ${WHO} ${ENDCOLOR} USER"

fi

if [ ${NGINX_STATUS} -ne 0 ]; then

    yum install nginx -y

    validate $? "NGIX IS NOT AVAILBLE SO INSTALLING NGINX"

else

    echo "NGINX ALREADY INSTALLED SO SKIPPING INSTALLATION"

fi   

