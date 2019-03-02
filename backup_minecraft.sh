#!/bin/sh
# run as minecraft user

SCREEN_NAME="mc-vanilla"

# make server read-only and save
# (eventually we may want to loop through *any* running servers)
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "save-off"\015'
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "save-all"\015'

sync && wait

# back up minecraft directory and push to google drive
cd /opt
tar czf - minecraft | drive push -fix-clashes -piped minecraft_$(date +%F_%R).tar.gz

# done - resume autosaving
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "save-on"\015'
