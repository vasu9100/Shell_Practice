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

if [ -e /home/centos/Shell_Practice/mongo.repo ]; then

    echo "Mongo.repo FILE  Is existed"
    cp -r /home/centos/mongo.repo /etc/yum.repos.d/
    validate $? "mongo.repo copied"
else

    echo "File is not existed Please Create"

fi

dnf list installed | grep -q "mongodb-org"
if [ $? -eq 0 ]; then

    echo "Mongo-DB Is Already Installed so Skipping Installation"

else

 echo "Mongo Db Is Not Installed SO Installing"
 dnf install mongodb-org -y
 validate $? "MONGO-DB-IS- INSTALLING" 
fi
systemctl enable mongod
validate $? "MONGO-DB-IS-ENABLING"

systemctl start mongod
validate $? "MONGO-DB-IS-STARTING"

if [ -e /etc/mongod.conf ]; then

    echo "Mongo.conf FILE IS THERE DOING BININD OPERATION"
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
    validate $?  "BINDING OPERATION"
    systemctl restart mongod
    validate $? "MONGO-DB RESTARTED"
    netstat -lntp
    validate $? "VERIFY PORTS"
    
    
else

    echo "FILE NOT EXISTED PLEASE RECHECK"

fi        
