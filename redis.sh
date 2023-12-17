#!/bin/bash

ID=$(id -u)
WHO=$(whoami)
WORKING_DIR=$(pwd)
DATE=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/tmp/$0-${DATE}.log"

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
echo "VALIDATING-REDIS REPO INSTALLED OR NOT" 

if dnf list installed | grep remi; then

    echo "REDIS REPO ALREADY INSTALLED NO NEED TO INSTALLED"

else

    echo "REDIS IS NOT INSTALLED SO INSTALLING"
    dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
    validate $? "REDIS INSTALLATION PART"
    dnf module enable redis:remi-6.2 -y
    validate $? "ENABLING REDIS REMI 6.2"
fi

if dnf list installed | grep redis ; then

    echo "REDIS ALREADY INSTALLED NO NEED TO INTSALL"

else

    echo "REDIS NOT INSTALLED SO SCRIPT STARTED INSTALLING" 
    dnf install redis -y
    validate $? "REDIS INSTALLATION PART" 
    echo "SCRIPT STARTS ADDING BINDING OPERATION"
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf

fi  
systemctl enable redis
validate $? "REDIS ENABLING"
systemctl start redis
validate $? "REDIS STARTED"
netstat -lntp
validate $? "SHOWING PORTS"

