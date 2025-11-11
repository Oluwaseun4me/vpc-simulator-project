#!/bin/bash

echo "Setting up VPC environment..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Install required packages
echo "Installing required packages..."
apt-get update
apt-get install -y iproute2 iptables python3 net-tools bridge-utils dos2unix curl

# Fix line endings and make executable
echo "Setting up scripts..."
dos2unix vpcctl >/dev/null 2>&1 || true
dos2unix scripts/*.sh >/dev/null 2>&1 || true
dos2unix examples/*.sh >/dev/null 2>&1 || true

chmod +x vpcctl
chmod +x scripts/*.sh
chmod +x examples/*.sh
chmod +x demo-video-script.sh

echo "Setup completed successfully!"
echo "You can now use ./vpcctl to manage your VPCs"
echo "Run './examples/demo_workloads.sh' to test the setup"