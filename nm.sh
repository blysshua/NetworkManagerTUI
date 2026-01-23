#!/usr/bin/env bash

set -e

line() { printf '%*s\n' "$(tput cols)" '' | tr ' ' '='; }

line
nmcli device status
line
nmcli device wifi list
line

while true; do
  read -rp "SSID: " SSID

  # Check for blank input
  if [[ -z "$SSID" ]]; then
      echo "SSID cannot be blank. Please try again."
      continue
  fi

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
  # Limit password attempts to 3
  for attempt in {1..3}; do
      read -rsp "Password: " PASSWORD
      echo
      if nmcli device wifi connect "$SSID" password "$PASSWORD"; then
          break
      else
          echo "Incorrect password. Attempt $attempt of 3."
          if [[ $attempt -eq 3 ]]; then
              echo "Failed to connect after 3 attempts. Exiting."
              exit 1
          fi
      fi
  done
fi

nmcli device status
