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