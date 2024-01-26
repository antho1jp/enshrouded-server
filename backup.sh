#!/bin/bash

# Location of the original folder to backup
SRCDIR=/home/janthony/steamcmd/Palworld-server/Pal/Saved/

# Data Save Directory
BACKUP_DIR=/home/janthony/projects/palworld-server/backups

# World Save File Retention
# This is how many files you want to retain in your backups directory. 
RETENTION=20

# Check for existing backup directory, if not, make one
if [[ ! -d $BACKUP_DIR ]]
then
        echo "The backup directory you specified does not exist. Creating it for you."
        mkdir -p $BACKUP_DIR
fi

DATE=$(date +'%Y-%d-%m-%H_%M_%S') # e.g. 2021-04-03-17_34_15
SUM=$((RETENTION+1))

# Backup File Name.
tar -czf $BACKUP_DIR/backup-$DATE.tar.tgz -C $SRCDIR SaveGames/

# Remove world save files greater than the retention value
ls -dt $BACKUP_DIR/* | tail -n +$SUM | xargs rm -rf

# Error Handling
exit_status=$?
if [ $exit_status -eq 0 ]; then
  echo "World save file successfully saved at $(date +'%Y-%d-%m %H:%M:%S %Z')"
elif [ $exit_status -ge 1 ]; then
  echo "There was an error with the backup script"
fi
