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
tar -cf vanilla.tar vanilla

# resume autosaving on server
screen -S ${SCREEN_NAME} -X eval 'stuff "save-on"\015'

# push archive to drive
drive push -no-prompt -ignore-conflict -ignore-name-clashes vanilla.tar
