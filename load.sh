#!/bin/bash

# 0. Discard local changes and make branch identical to origin/main
git fetch origin
git reset --hard origin/main

. $HOME/Desktop/run.sh
