#!/bin/bash

# Wait until the host is reachable (network and DNS are ready)
HOST="https://gitcc.mwit.ac.th"

echo "Checking network connectivity to $HOST..."
until curl -s --head "$HOST" >/dev/null; do
    echo "Waiting for network/DNS to resolve $HOST..."
    sleep 5
done

echo "Network is ready."

# Discard local changes and make branch identical to origin/main
cd /home/admin/Desktop

#~ git fetch origin
#~ git reset --hard origin/main

. /home/admin/Desktop/run.sh
