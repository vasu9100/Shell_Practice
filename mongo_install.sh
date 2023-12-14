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



find /etc/yum.repos.d/ -type f -name "mongo.repo"

if [ $? -ne 0 ]; then

    cp /home/centos/Shell_Practice/mongo.repo /etc/yum.repos.d
    validate $? "Mongo Repo File Transfer"
else
    echo -e " $2.... ${YELLOW} Skipping " 
 fi   


echo -e "${YELLOW}Shell is Verifying MongoDB Installation on Server."

dnf list installed | grep -q mongodb-org

if [ $? -ne 0 ]; then
    
    echo "Mongo Db Already Installed no Need to Install"
else
    dnf install mongodb-org -y 
    validate $? "MongoDB-ORG Installation" 
 fi 

systemctl enable mongod
validate $? "MongoDB Enabled"

systemctl start mongod
validate $? "MongoDB Started"
