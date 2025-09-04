#!/bin/bash

SRC="/home/admin/Downloads/rpi-setup"
DEST="/home/admin/Desktop"

if [ -d "$SRC" ]; then
    echo "Copying all files (including hidden ones) from $SRC to $DEST..."
    sudo cp -r "$SRC"/. "$DEST"/
    echo "Copy completed."
else
    echo "Source directory $SRC does not exist!"
fi

CRON_CMD='@reboot . /home/admin/Desktop/load.sh >> /home/admin/cron.log 2>&1'

if ! crontab -l 2>/dev/null | grep -Fxq "$CRON_CMD"; then
    (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
    echo "Cron job added: $CRON_CMD"
else
    echo "Cron job already exists, skipping."
fi
