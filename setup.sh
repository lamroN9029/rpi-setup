#!/bin/bash

CRON_CMD='@reboot . /home/admin/Desktop/load.sh >> /home/admin/cron.log 2>&1'

if ! crontab -l 2>/dev/null | grep -Fxq "$CRON_CMD"; then
    (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
    echo "Cron job added: $CRON_CMD"
else
    echo "Cron job already exists, skipping."
fi
