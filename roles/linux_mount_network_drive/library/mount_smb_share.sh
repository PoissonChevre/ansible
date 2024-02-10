#!/bin/bash

#########################################################################################
# Script to Mount SMB Share with Kerberos authentication
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
#
# Good coding practices: variables, header, comments, environment variables & condition
#########################################################################################

# specify the SMB share path and the mount point
smb_share="//SRV-INF-001/BARZINI_SHARE"
mount_point="$HOME/BARZINI_SHARE"

# capture current user ID/group ID in variables
uid=$(id -u $LOGNAME)
gid=$(id -g $LOGNAME)

# check if the user can execute mount command with sudo && without a password
if ! sudo -ln 2>/dev/null | grep -q mount; then
    echo "You do not have sudo rights to mount SMB shares. Please check your sudoers configuration."
    break
fi

# create the mount point directory if it does not exist
if [ ! -d "$mount_point" ]; then
    mkdir -p "$mount_point" || { echo "Failed to create the mount point directory."; break; }
fi

# attempt to mount the SMB share with Kerberos authentication
# using 'sec=krb5' for Kerberos for security and specifying UID/GID for file access permissions
if ! sudo mount -t cifs "$smb_share" "$mount_point" -o sec=krb5,uid=$uid,gid=$gid; then
    echo "Failed to mount the SMB share."
    break
fi

echo "Successfully mounted the SMB share at $mount_point."