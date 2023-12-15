#!/bin/bash

# Author :: Srinivas Gonepudi 
# Created Date :: 15-12-2023
# Description ::  Mongo-Db Installation Process

# Starting Shell Script

validate() {
    [[ $1 -eq 0 ]] || { echo "Error: $2"; exit 1; }
}

ID=$(id -u)
WHO=$(whoami)
REPO_SOURCE="/home/centos/Shell_Practice/mongo.repo"
REPO_DEST="/etc/yum.repos.d/"
MONGO_INSTALLED=$(rpm -qa | grep "mongodb-org" && echo "true" || echo "false")
MONGO_INSTALLING="dnf install mongodb-org -y"
MONGO_CONF="sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf"

validate $ID ":: YOU ARE USING ${WHO} USER SO YOU CANNOT EXECUTE THIS SCRIPT::"
echo ":: YOU ARE A ${WHO} USER. YOU CAN EXECUTE THIS SCRIPT::"
echo "SCRIPT EXECUTION WILL START NOW"

[[ -e "${REPO_DEST}mongo.repo" ]] && echo "FILE ALREADY EXISTS IN ${REPO_DEST} SO, SKIPPING COPYING ::" || { cp "${REPO_SOURCE}" "${REPO_DEST}"; echo "IT IS A NEW FILE IN ${REPO_DEST} SO, COPYING TO DESTINATION PATH i.e ${REPO_DEST}  ::"; }

[[ "${MONGO_INSTALLED}" == "true" ]] && echo "MONGO DB INSTALLED ALREADY:: SO SKIPPING INSTALLATION PART" || { echo ":: MONGO-DB IS INSTALLING ::"; ${MONGO_INSTALLING}; validate $? ":: MONGO-DB INSTALLATION FAILED ::"; echo "$?:: MONGO-DB IS INSTALLED ::"; systemctl enable mongod; validate $? ":: MONGO-DB ENABLING FAILED ::"; systemctl start mongod; validate $? ":: MONGO-DB STARTING FAILED ::"; }

[[ $(grep -q "127.0.0.1" /etc/mongod.conf && echo "true" || echo "false") == "true" ]] && { echo "127.0.0.1 IS FOUND:: REPLACING WITH 0.0.0.0"; ${MONGO_CONF}; validate $? "SED command failed."; echo "SED command executed successfully."; systemctl restart mongod; } || echo "127.0.0.1 IS NOT FOUND:: REPLACING WITH 0.0.0.0 IS NOT POSSIBLE"
