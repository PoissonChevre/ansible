# Author: Renaud Charlier
# Date: 05-02-24
# Version: 1.0
#
# Description:
# Bash script to mount a network drive on an Ubuntu machine.
# Assumes the use of SMB/CIFS for Active Directory environments.
#
# Usage:
# Modify the script variables with your specific information.
# Execute with sudo: sudo ./mount_network_drive.sh
#

set -euo pipefail

# Server details
server_address="srv-inf-001"
share_name="BARZINI_SHARE"
mount_point="/mnt/S"

# Active Directory credentials
ad_username="u.ansible"
ad_password="BARzini&1979"

# Function to check if the directory exists and create if not
create_mount_point() {
    if [ ! -d "$mount_point" ]; then
        mkdir -p "$mount_point"
    fi
}

# Mount the network drive
mount_network_drive() {
    sudo mount.cifs //$server_address/$share_name $mount_point -o username=$ad_username,password=$ad_password,sec=ntlmssp
}

# Main execution
main() {
    create_mount_point
    mount_network_drive

    # Check if the mount was successful
    if [ $? -eq 0 ]; then
        echo "Network drive successfully mounted to $mount_point"
    else
        echo "Failed to mount network drive"
    fi
}

# Run the main function
main