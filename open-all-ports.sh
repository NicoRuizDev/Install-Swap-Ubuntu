#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script needs to be run as root."
  exit 1
fi

# Ask for confirmation
read -p "This script will create a systemd service to reset iptables rules on boot. Do you want to proceed? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Aborting script."
  exit 1
fi

# Create the script file
cat <<EOL > /root/iptables-reset.sh
#!/bin/bash

# Reset iptables rules to allow all traffic
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
EOL

# Make the script executable
chmod +x /root/iptables-reset.sh

# Create the systemd service unit file
cat <<EOL > /etc/systemd/system/iptables-reset.service
[Unit]
Description=Reset iptables rules on boot

[Service]
Type=oneshot
ExecStart=/root/iptables-reset.sh

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable iptables-reset.service

# Start the service
systemctl start iptables-reset.service

echo "Systemd service for resetting iptables rules on boot has been created and enabled."

exit 0
