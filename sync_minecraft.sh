#!/bin/sh

MINECRAFT_USER="minecraft"
MINECRAFT_DIR="/opt/minecraft"
SCREEN_NAME="mc-vanilla"

# make server read-only and save
# (eventually we may want to loop through *any* running servers)
su $MINECRAFT_USER -c "screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-off\"\015'"
su $MINECRAFT_USER -c "screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-all\"\015'"
sync

sleep 10

# push minecraft directory to google drive
su $MINECRAFT_USER -c "cd $MINECRAFT_DIR && drive push"

# done - resume autosaving
su $MINECRAFT_USER -c "screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff \"save-on\"\015'"

