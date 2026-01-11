#!/usr/bin/env bash

set -e

nmcli device status
echo
nmcli device wifi list
echo

while true; do
  read -rp "SSID: " SSID

  if nmcli -t -f IN-USE,SSID device wifi list | cut -d: -f2- | grep -Fxq "$SSID"; then
    break
  else
    echo "SSID not found. Please try again."
  fi
done

# Check if connection already exists
if nmcli -t -f NAME connection show | grep -Fxq "$SSID"; then
  echo "Using existing connection: $SSID"
  nmcli connection up "$SSID"
else
  read -rsp "Password: " PASSWORD
  echo
  nmcli device wifi connect "$SSID" password "$PASSWORD"
fi

nmcli device status
