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

which node &>> $LOG_FILE
validate $? "CHECKINGG NODE JS 18 INSTALLED OR NOT"

if [ $? -eq 0 ]; then

    echo  "NODE-JS ALREDAY INSTALLED, SO SKIPPING INSTALLATION"

else    
    echo "NODE-JS NOT INSTALLED SO STARTED INSTALLATION"
    dnf module disable nodejs -y
    validate $? "NODE-JS DISABLED"
    dnf module enable nodejs:18 -y
    validate $? "NODEJS-18 VERSION ENABLED"
    dnf install nodejs -y
    validate $? "NODEJS-18 VERSION INSTALLATION"
fi

id roboshop &>> ${LOG_FILE}

if [ $? -eq 0 ]; then

    echo "User already Existed so Skipping User creation"
else
    echo "ROBO-SHOP-USER IS CREATING"
    useradd roboshop
    validate $? "ROBO-SHOP-USER-CREATING"
    
fi   

grep -r "web.zip" /tmp

if [ $? -eq 0 ]; then

    echo " FRONT END ALREADY DOWNLOADED,SO SKIPPING DOWNLOADING PART"
else

    curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
    validate $? "FRONT END DOWNLOADING"
fi    
