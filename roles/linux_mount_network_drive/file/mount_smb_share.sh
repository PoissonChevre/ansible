#!/bin/bash

#########################################################################################
# Script to Mount SMB Share with Kerberos Authentication
#
# Description:
# This script automates the process of mounting an SMB share using
# Kerberos for authentication. It leverages the current user's environment
# variables and assumes a valid Kerberos ticket is already obtained
# or will be automatically obtained during the mount process.
# 
# Usage:
#   ./mount_smb_share.sh
# 
# Author: Charlier Renaud
# Date: 07-02-2024
# Version: 1.0
# 
# Dependencies:
#   - keyutils
#   - cifs-utils
# Install Dependencies: sudo apt-get install keyutils cifs-utils
# 
# Notes:
#   - Ensure the user has necessary permissions for mounting and Kerberos authentication.
#   - Customize SMB share path and mount point.

# Good coding practices: variables, header, comments, environment variables & condition
#########################################################################################

# Specify the SMB share path and the mount point
smb_share="//SRV-INF-001/BARZIN_SHARE"
mount_point="$HOME/BARZINI_SHARE"

# Capture current user ID/group ID in variables
uid=$(id -u $USER)
gid=$(id -g $USER)

# Create the mount point directory if it does not exist
if [ ! -d "$mount_point" ]; then
    sudo mkdir -p "$mount_point"
fi

# Attempt to mount the SMB share with Kerberos authentication
# Using 'sec=krb5' for Kerberos security and specifying UID/GID for file access permissions
if ! sudo mount -t cifs "$smb_share" "$mount_point" -o sec=krb5,uid=$uid,gid=$gid; then
    echo "Failed to mount the SMB share."
    exit 1
fi

echo "Successfully mounted the SMB share at $mount_point."
