#!/bin/bash

# Demo script to showcase VPC functionality

set -e

VPCCTL="./vpcctl"

echo "=== VPC Demo Starting ==="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Clean up any existing resources
"$VPCCTL" cleanup-all

# Create VPCs
echo "Creating VPCs..."
"$VPCCTL" create-vpc vpc1 10.0.0.0/16
"$VPCCTL" create-vpc vpc2 10.1.0.0/16

# Create subnets
echo "Creating subnets..."
"$VPCCTL" create-subnet vpc1 public public 10.0.1.0/24
"$VPCCTL" create-subnet vpc1 private private 10.0.2.0/24
"$VPCCTL" create-subnet vpc2 public public 10.1.1.0/24
"$VPCCTL" create-subnet vpc2 private private 10.1.2.0/24

# Deploy workloads
echo "Deploying workloads..."
"$VPCCTL" deploy-workload vpc1 public web1 10.0.1.10
"$VPCCTL" deploy-workload vpc1 private app1 10.0.2.10
"$VPCCTL" deploy-workload vpc2 public web2 10.1.1.10
"$VPCCTL" deploy-workload vpc2 private app2 10.1.2.10

# List everything
echo "Current setup:"
"$VPCCTL" list

echo ""
echo "=== Testing Connectivity ==="

# Test connectivity within VPC
echo "1. Testing connectivity within VPC1 (should work):"
"$VPCCTL" test-connectivity subnet-vpc1-public 10.0.2.10

# Test isolation between VPCs
echo ""
echo "2. Testing isolation between VPCs (should fail):"
"$VPCCTL" test-connectivity subnet-vpc1-public 10.1.1.10

# Create peering
echo ""
echo "3. Creating VPC peering..."
"$VPCCTL" create-peering vpc1 vpc2

# Test connectivity after peering
echo ""
echo "4. Testing connectivity after peering (should work):"
"$VPCCTL" test-connectivity subnet-vpc1-public 10.1.1.10

# Test web servers
echo ""
echo "5. Testing web servers:"
echo "Testing web1 in VPC1 public subnet:"
ip netns exec subnet-vpc1-public curl -s --connect-timeout 3 http://10.0.1.10:80 | grep -o "<h1>.*</h1>" || echo "Failed to connect"

echo "Testing web2 in VPC2 public subnet:"
ip netns exec subnet-vpc1-public curl -s --connect-timeout 3 http://10.1.1.10:80 | grep -o "<h1>.*</h1>" || echo "Failed to connect"

echo ""
echo "=== Demo Completed ==="
echo "Run './vpcctl cleanup-all' to remove all resources"