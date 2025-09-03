#!/bin/bash
# Kill the jupyterhub process

# Find PID of jupyterhub
PID=$(pgrep -f 'jupyterhub')

# kill -2  | SIGINT
# kill -15 | SIGTERM
# kill -9  | SIGKILL

if [ -n "$PID" ]; then
  echo "Killing jupyterhub process PID: $PID"
  kill -2 $PID   # SIGINT, like Ctrl+C
else
  echo "No jupyterhub process found"
fi
