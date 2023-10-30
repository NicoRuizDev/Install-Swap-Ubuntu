if [ "$EUID" -ne 0 ]; then
  echo "This script needs to be run as root."
  exit 1
fi

read -p "This script will reset your iptables rules to default and save them to ~/iptables-rules. Do you want to continue? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Aborting script."
  exit 1
fi

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
sudo iptables-save > ~/iptables-rules

echo "Successfully done."

echo "Check out my GitHub repository for more scripts and projects: https://github.com/NicoRuizDev/Scripts"
