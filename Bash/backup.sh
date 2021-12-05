#!/bin/bash

if [ "$(id -u)" -ne 0 ]
then
    printf "ERROR! This script must be run by root\n\n"
    exit 1
fi


if [ -z "$1" ]
then
    printf "Please specify a folder to backup"
    exit 2
else
    backupPath=$1
    printf "This script will make a backup of folder $backupPath"
fi


printf "Checking if the folder exists..."
if [ -d $backupPath ]
then
    printf "$backupPath exists"
else
    printf "$backupPath does not exist"
    exit 2
fi


# Make backupdir
if [ -d "/BackupDir" ]
then
    printf "Already exists"
else
    mkdir /BackupDir
    printf "BackupDir created \n\n"
fi


now=$(date +"%d_%m_%Y")
BackupFile="/BackupDir/backup-${now}.tar.gz"
tar -cvf $BackupFile $backupPath
printf "Finished"