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

dnf module disable nodejs -y
validate $? "NODE-JS DISABLED"
dnf module enable nodejs:18 -y
validate $? "NODEJS-18 VERSION INSTALLATION"