#!/bin/bash

# Get MAC addresses (use fallback N/A if interface not found)
WIFI_MAC=$(cat /sys/class/net/wlan0/address 2>/dev/null || echo "N/A")
LAN_MAC=$(cat /sys/class/net/eth0/address 2>/dev/null || echo "N/A")

# Print header
printf "Wi-Fi (wlan0) Mac Address\tLAN (eth0) Mac Address\n"

# Print values
printf "%s\t%s\n" "$WIFI_MAC" "$LAN_MAC"