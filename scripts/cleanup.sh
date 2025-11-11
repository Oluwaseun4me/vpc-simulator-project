#!/bin/bash

# Cleanup script for VPC resources

echo "Starting VPC cleanup..."

# Clean up using vpcctl
./vpcctl cleanup-all

# Additional cleanup for any orphaned resources
echo "Cleaning up orphaned resources..."

# Remove orphaned network namespaces
for ns in $(ip netns list | grep -E '(vpc-|subnet-)' | cut -d' ' -f1); do
    echo "Removing orphaned namespace: $ns"
    ip netns del $ns
done

# Remove orphaned bridges
for br in $(brctl show | grep 'br-' | cut -f1); do
    echo "Removing orphaned bridge: $br"
    ip link del $br
done

# Remove orphaned veth interfaces
for iface in $(ip link show | grep 'veth-' | cut -d':' -f2 | tr -d ' '); do
    echo "Removing orphaned interface: $iface"
    ip link del $iface
done

# Clean up iptables rules
iptables -t nat -F
iptables -F

echo "Cleanup completed!"