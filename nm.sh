#!/usr/bin/env bash

set -e

nmcli device status
echo
nmcli device wifi list
echo

read -rp "SSID: " SSID

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
