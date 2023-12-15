#!/bin/bash

# Author :: Srinivas Gonepudi 
# Created Date :: 15-12-2023
# Description ::  Mongo-Db Installation Process

# Starting Shell Script

ID=$(id -u)
WHO=$(whoami)
REPO_SOURCE="/home/centos/Shell_Practice/mongo.repo"
REPO_DEST="/etc/yum.repos.d/"
MONGO_INSTALLED=$(rpm -qa | grep "mongodb-org" && echo "true" || echo "false")
MONGO_INSTALLING="dnf install mongodb-org -y"
MONGO_CONF=$(grep -q "127.0.0.1" /etc/mongod.conf && echo "true" || echo "false")
SED="sed -i 's/127.0.0.1/0.0.0.0/'"

# Function to print messages with colors
print_message() {
    local color="$1"
    local message="$2"
    echo -e "\e[${color}m${message}\e[0m"
}

# ---- ---- Checking User ---- ----
if [ $ID -ne 0 ]; then
    print_message "1;31" " :: YOUR ARE USING ${WHO} USER. YOU CANNOT EXECUTE THIS SCRIPT:: "
    exit 1
else
    print_message "1;36" " :: YOU ARE A ${WHO} USER. YOU CAN EXECUTE THIS SCRIPT:: "
fi

# ---- ---- Starting Script ---- ----
print_message "1;36" " SCRIPT EXECUTION WILL START NOW "

# ---- ---- Checking Repo File ---- ----
if [ -e "${REPO_DEST}mongo.repo" ]; then
    print_message "1;33" " FILE ALREADY EXISTS IN ${REPO_DEST}. SKIPPING COPYING ::"
else
    cp "${REPO_SOURCE}" "${REPO_DEST}"
    print_message "1;32" " IT IS A NEW FILE IN ${REPO_DEST}. COPYING TO DESTINATION PATH: ${REPO_DEST}  ::"
fi

# ---- ---- Checking MongoDB Installation ---- ----
if [ "${MONGO_INSTALLED}" == "true" ]; then
    print_message "1;32" " MONGO DB IS ALREADY INSTALLED. SKIPPING INSTALLATION PART"
else
    # ---- ---- Installing MongoDB ---- ----
    print_message "1;36" ":: MONGO-DB IS INSTALLING ::"
    ${MONGO_INSTALLING}
    print_message "$?" "$?:: MONGO-DB IS INSTALLED ::"

    # ---- ---- Enabling MongoDB ---- ----
    systemctl enable mongod
    print_message "$?" "$?:: MONGO-DB IS ENABLED ::"

    # ---- ---- Starting MongoDB ---- ----
    systemctl start mongod
    print_message "$?" "$?:: MONGO-DB IS STARTED ::"
fi    

# ---- ---- Modifying MongoDB Configuration ---- ----
if [ "${MONGO_CONF}" == "true" ]; then
    # ---- ---- Modifying MongoDB Configuration File ---- ----
    print_message "1;36" " 127.0.0.1 IS FOUND. REPLACING WITH 0.0.0.0  "
    ${SED}
    if [ $? -eq 0 ]; then
        print_message "1;32" "SED COMMAND EXECUTED SUCCESSFULLY."

        # ---- ---- Restarting MongoDB ---- ----
        systemctl restart mongod
    else
        print_message "1;31" "ERROR: SED COMMAND FAILED."
    fi
else
    print_message "1;31" " 127.0.0.1 IS NOT FOUND. REPLACING WITH 0.0.0.0 IS NOT POSSIBLE "
fi
