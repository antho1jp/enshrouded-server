#!/bin/bash

# assumes you are running your game server as a service
# -s SERVICE=enshrouded
# Folder location of steamcmd
# -f STEAMCMDFOLDER=/home/janthony/steamcmd
# Steam App ID of the game
# -i STEAMAPPID=2278520

# run command example:
# bash /home/janthony/projects/enshrouded-server/update.sh -s enshrouded -f /home/janthony/steamcmd -i 2278520

# set flags as vars
while getopts s:f:g:i: flag
do
    case "${flag}" in
        s) SERVICE=${OPTARG};;
        f) STEAMCMDFOLDER=${OPTARG};;
        i) STEAMAPPID=${OPTARG};;
    esac
done

# validate the flags exist
if [ -z "${SERVICE}" ]; then
    echo "-s Service Name was not passed. use flag -s followed by the name of the service."
    exit 1
fi

if [ -z "${STEAMCMDFOLDER}" ]; then
    echo "-f STEAMCMD FOLDER was not passed. use flag -f followed by the folder path."
    exit 1
fi

if [ -z "${STEAMAPPID}" ]; then
    echo "-i STEAM APP ID was not passed. use flag -i followed by the ID"
    exit 1
fi

# Check if palworld is running
STATUS="$(systemctl is-active ${SERVICE}.service)"
if [ "${STATUS}" = "active" ]; then
    echo "${SERVICE} is running. Can not update the service." 
else
    echo "${SERVICE} is stopped. Running update command."

    # assumes you have steamcmd installed
    if [[ ! -f "${STEAMCMDFOLDER}/steamcmd.sh" ]]; then
        echo "Failure fetching steamcmd to update ${SERVICE}."
        exit 1
    fi  

    echo "updating game at location: ${STEAMCMDFOLDER}/${SERVICE}"

    # Perform update
    "${STEAMCMDFOLDER}/steamcmd.sh" +login anonymous +force_install_dir ${STEAMCMDFOLDER}/${SERVICE} +app_update ${STEAMAPPID} validate +exit | grep 'Success!'
    result=$?

    if [ $result -ne 0 ]; then
        echo "Failure when running updates for ${SERVICE}."
        exit 1
    fi
fi

