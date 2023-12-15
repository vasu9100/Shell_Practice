#!/bin/bash

# Author :: Srinivas Gonepudi 
# Created Date :: 15-12-2023
# Description ::  Mongo-Db Installation Process

# Starting Shell Script

ID=$(id -u)
WHO=$(whoami)
REPO_SOURCE="/home/centos/Shell_Practice/mongo.repo"
REPO_DEST="/etc/yum.repos.d/"
MONGO_INSTALLED=MONGO_INSTALLED=$(dnf list installed | grep "mongodb-org" && echo "true" || echo "false")
MONGO_INSTALLING=$(dnf install mongodb-org -y)
MONGO_CONF=$(grep -q "127.0.0.1" /etc/mongod.conf && echo "true" || echo "false")
SED=$(sed -i 's/127.0.0.1/0.0.0.0/')

if [ $ID -ne 0 ]; then

    echo " :: YOUR USING ${WHO} USER SO YOU CANNOT EXECUTE THIS SCRIPT:: "
    exit 1
else

    echo " :: YOUR ARE A ${WHO} USER YOU CAN EXCEUTE THIS SCRIPT:: "

fi

echo " SCRIPT EXCECUTION WILL START NOW "

if [ -e "${REPO_DEST}mongo.repo" ]; then

    echo " FILE ALREADY EXISTING IN ${REPO_DEST} SO, SKIPPING COPYING ::"

else

    cp "${REPO_SOURCE}" "${REPO_DEST}"

    echo "  IT IS NEW FILE IN ${REPO_DEST} SO, COPYING IN DESTINATION PATH i.e ${REPO_DEST}  ::"
fi


if [ "${MONGO_INSTALLED}" == "true" ]; then

    echo "MONGO DB INSTALLED ALREADY:: SO SKIPPING INSTALLATION PART"

else

    echo ":: MONGO-DB IS INSTALLING ::"
    ${MONGO_INSTALLING}
    echo "$?::  MONGO-DB IS INSTALLED ::"
    systemctl enable mongod
    echo "$?:: MONGO-DB IS ENABLED ::"
    systemctl start mongod
    echo "$?:: MONGO-DB IS STARTED ::"
fi    


if [ "${MONGO_CONF}" == "true" ]; then

    echo " 127.0.0.1 IS FOUND:: SO, IT IS REPLACING with 0.0.0.0  "
    ${SED}
    if [ $? -eq 0 ]; then
        echo "SED command executed successfully."
        systemctl restart mongod
    else
        echo "Error: SED command failed."
    fi
    

else

    echo " 127.0.0.1 IS NOT FOUND:: SO,  REPLACING with 0.0.0.0 IS NOT POSSIBLE "
fi