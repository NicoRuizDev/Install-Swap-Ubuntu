#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "This script needs to be run as root."
  exit 1
fi
read -p "This script will install a cron job to restart the server at regular intervals. Do you want to proceed? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Aborting script."
  exit 1
fi
read -p "Enter the interval in hours for server restart (e.g., 1 for every hour): " interval
temp_cron=$(mktemp)
crontab -l > "$temp_cron"
echo "0 */$interval * * * /sbin/reboot" >> "$temp_cron"
crontab "$temp_cron"
rm "$temp_cron"
echo "Cron job for server restart every $interval hour(s) installed successfully."
exit 0
