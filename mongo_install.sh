#!/bin/bash
# Author: Srinivas Gonepudi
# Created Date: 14-12-2023
# Description: Installing MongoDB For RoboShop Application
# Modified date: 14-12-2023

ID=$(id -u)
WHO=$(whoami)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
N='\033[0m'

validate() {
    if [ "$1" -ne 0 ]; then
        echo -e " $2.... ${RED} FAILED"
        exit 1
    else
        echo -e " $2.... ${GREEN} SUCCESS"
    fi
}

if [ "$ID" -ne 0 ]; then
    echo -e "${RED} ERROR:: ${N} You are not a Root User : You are a ${YELLOW}${WHO}${N} user : Please switch to ${RED}Root${N} User"
    exit 1
else
    echo -e "${GREEN} SUCCESS:: ${N} You are now ${YELLOW}${WHO}${N} User. The script will execute shortly: ${GREEN}PLEASE WAIT ${N}"
fi

mv /home/centos/Shell_Practice/mongo.repo /etc/yum.repos.d
validate $? "Mongo Repo File Transfer"

echo -e "${YELLOW}Shell is Verifying MongoDB Installation on Server."

dnf list installed | grep -q mongodb-org
validate $? "Mongo DB is not installed"

echo -e "${YELLOW}Shell is Installing MongoDB."

dnf install mongodb-org -y 
validate $? "MongoDB-ORG Installation"

systemctl enable mongod
validate $? "MongoDB Enabled"

systemctl start mongod
validate $? "MongoDB Started"
