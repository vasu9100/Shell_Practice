#!/bin/bash
# Author: Srinivas Gonepudi
# Created Date : 14-12-2023
# Description : Installing Mongodb For Roboshop Application
#Modified date : 14-12-2023

ID=$(id -u)
WHO=$(whoami)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
N='\033[0m'

if [ "$ID" -ne 0 ]; then

    echo -e "ERROR :: Your Not a RooT User : Your a ${YELLOW}${WHO} user : Please switch to ${RED}Root${N} User"
else

    echo -e "SUCCESS :: Your Now ${YELLOW}${WHO}User So Script Will Exceute Shortly: ${GREEN}PLEASE WAIT${N}"
fi      
