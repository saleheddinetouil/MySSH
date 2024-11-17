#!/bin/sh

# No-IP credentials from environment variables
USERNAME="$NOIP_USERNAME"
PASSWORD="$NOIP_PASSWORD"
HOSTNAME="$NOIP_HOSTNAME"

# Update No-IP
curl -u $USERNAME:$PASSWORD "http://dynupdate.no-ip.com/nic/update?hostname=$HOSTNAME"

# Display the No-IP hostname
echo "No-IP hostname updated: $HOSTNAME"