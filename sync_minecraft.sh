#!/bin/sh
# run as minecraft user

SCREEN_NAME="mc-vanilla"

# make server read-only and save
# (eventually we may want to loop through *any* running servers)
screen -S ${SCREEN_NAME} -X eval 'stuff \015'
screen -S ${SCREEN_NAME} -X eval 'stuff "save-off"\015'
screen -S ${SCREEN_NAME} -X eval 'stuff "save-all"\015'

sync && wait

cd /opt/minecraft
# archive server directory
rm -f /opt/minecraft/vanilla.tar
tar -cf /opt/minecraft/vanilla.tar /opt/minecraft/vanilla

# resume autosaving on server
screen -S ${SCREEN_NAME} -X eval 'stuff "save-on"\015'

# push archive to drive
drive trash -quiet vanilla.tar
drive push -no-prompt -quiet vanilla.tar

#Backup magic
mkdir /opt/minecraft/backup
cd /opt/minecraft/backup

DATE_STAMP=`date "+%Y-%m-%d-%H_%M"`

tar -czvf /opt/minecraft/backup/vanilla_$DATE_STAMP.tar.gz /opt/minecraft/vanilla
drive push -no-prompt -quiet vanilla_$DATE_STAMP.tar.gz

#Delete backups older than 60 days
find /opt/minecraft/backup -type f -mtime +60 -exec drive trash -quiet {}
find . -type f -mtime +60 -delete
