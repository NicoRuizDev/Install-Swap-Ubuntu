#!/bin/bash

# Function to install swap
install_swap() {
    echo "Enter the size of swap you want to install (e.g., 1G for 1 gigabyte):"
    read swap_size
    sudo fallocate -l $swap_size /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "Swap of size $swap_size installed successfully."
}

# Function to remove swap
remove_swap() {
    if [ -f /swapfile ]; then
        sudo swapoff /swapfile
        sudo rm /swapfile
        sudo sed -i '/swapfile/d' /etc/fstab
        echo "Swap removed successfully."
    else
        echo "No swap file found. Nothing to remove."
    fi
}

# Main menu
echo "Select an option:"
echo "1. Install Swap"
echo "2. Remove Swap"
echo "3. Quit"
read choice

case $choice in
    1)
        install_swap
        ;;
    2)
        remove_swap
        ;;
    3)
        echo "Exiting script."
        ;;
    *)
        echo "Invalid option. Please select 1, 2, or 3."
        ;;
esac
