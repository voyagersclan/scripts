#!/bin/sh
# run as minecraft user

SCREEN_NAME="mc-vanilla"

# make server read-only and save
# (eventually we may want to loop through *any* running servers)
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-off\"\015'
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-all\"\015'
sync

sleep 10

# push minecraft directory to google drive
cd /opt/minecraft
drive push -no-prompt -ignore-conflict

# done - resume autosaving
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-on\"\015'
