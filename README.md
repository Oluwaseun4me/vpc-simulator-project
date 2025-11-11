Local Linux VPC Emulator

A bash-based Virtual Private Cloud (VPC) emulation environment that replicates cloud networking features on a Linux host. Perfect for development, testing, and learning cloud networking concepts without cloud costs.
🚀 Features

    Full VPC Emulation: Create and manage virtual private clouds with subnets

    Network Isolation: Linux network namespaces for complete isolation

    Security Groups: JSON-based firewall rules with ingress/egress controls

    Multi-Tier Architectures: Support for web, app, and database tiers

    Real Cloud Patterns: Implements AWS VPC-like networking concepts

    Demo Workloads: Pre-configured use cases for testing and validation

    Easy Cleanup: Complete environment teardown with single command

📁 Project Structure
text

local-linux-vpc/
├── vpcctl                          # Main VPC control script (Bash)
├── config/
│   └── firewall_rules.json         # Security group definitions
├── scripts/
│   ├── setup.sh                    # Environment initialization
│   ├── cleanup.sh                  # Resource cleanup
│   ├── demo_workloads.sh           # Use case demonstrations
│   └── demo-video-script.sh        # Documentation automation
├── examples/                       # Sample configurations
└── README.md                       # This documentation

🛠 Requirements

    Linux OS with kernel 4.0+

    Bash 4.0 or higher

    Root privileges (for network configuration)

    iproute2 suite

    iptables or nftables

    jq (for JSON processing in firewall rules)

Install Dependencies

Ubuntu/Debian:
bash

sudo apt update
sudo apt install iproute2 iptables jq

CentOS/RHEL:
bash

sudo yum install iproute iptables jq

⚡ Quick Start
1. Make Scripts Executable
bash

chmod +x vpcctl scripts/*.sh

2. Initialize Environment
bash

sudo ./scripts/setup.sh

3. Create Your First VPC
bash

sudo ./vpcctl create-vpc --name my-vpc --cidr 10.0.0.0/16

4. Create Subnets
bash

sudo ./vpcctl create-subnet --vpc my-vpc --name public-subnet --cidr 10.0.1.0/24 --type public
sudo ./vpcctl create-subnet --vpc my-vpc --name private-subnet --cidr 10.0.2.0/24 --type private

5. Apply Security Rules
bash

sudo ./vpcctl apply-firewall-rules config/firewall_rules.json

6. Test with Demo Workloads
bash

sudo ./scripts/demo_workloads.sh

📖 Usage Guide
VPC Management

Create a VPC:
bash

sudo ./vpcctl create-vpc --name production --cidr 10.0.0.0/16

List VPCs:
bash

sudo ./vpcctl list-vpcs

Delete a VPC:
bash

sudo ./vpcctl delete-vpc --name production

Subnet Management

Create Subnet:
bash

sudo ./vpcctl create-subnet --vpc production --name web-tier --cidr 10.0.1.0/24 --type public

Available Subnet Types:

    public: Route to internet (if gateway configured)

    private: Internal only

    isolated: No internet or internal routing

Security Groups

Apply Firewall Rules:
bash

sudo ./vpcctl apply-firewall-rules path/to/rules.json

Example Firewall Rules:
json

{
  "vpc_name": "production",
  "security_groups": [
    {
      "name": "web-sg",
      "description": "Web tier security group",
      "ingress_rules": [
        {
          "protocol": "tcp",
          "port_range": "80,443",
          "source": "0.0.0.0/0",
          "description": "HTTP/HTTPS from anywhere"
        }
      ],
      "egress_rules": [
        {
          "protocol": "tcp",
          "port_range": "1-65535",
          "destination": "0.0.0.0/0",
          "description": "Full outbound access"
        }
      ]
    }
  ]
}

🎯 Demo Scenarios

Run the demo script to see common use cases:
bash

sudo ./scripts/demo_workloads.sh

Included Demos:

    Three-Tier Architecture: Web → Application → Database

    Public/Private Subnet: Internet-facing and internal services

    Security Group Testing: Validate ingress/egress rules

    Cross-Subnet Communication: Verify routing between subnets

🛠 Advanced Usage
Custom Network Topologies

Create complex network designs:
bash

# Create VPC with multiple subnets
sudo ./vpcctl create-vpc --name complex-app --cidr 172.16.0.0/20

# Create different subnet types
sudo ./vpcctl create-subnet --vpc complex-app --name public-web --cidr 172.16.1.0/24 --type public
sudo ./vpcctl create-subnet --vpc complex-app --name private-app --cidr 172.16.2.0/24 --type private
sudo ./vpcctl create-subnet --vpc complex-app --name isolated-db --cidr 172.16.3.0/24 --type isolated

Manual Network Testing

Test connectivity between namespaces:
bash

# Ping from web to app tier
sudo ip netns exec web-ns ping 10.0.2.10

# Test port connectivity
sudo ip netns exec web-ns nc -zv 10.0.3.10 3306

# Trace route between subnets
sudo ip netns exec web-ns traceroute 10.0.2.1

🧹 Cleanup

Remove all VPC resources:
bash

sudo ./scripts/cleanup.sh

Remove specific VPC:
bash

sudo ./vpcctl delete-vpc --name my-vpc

🔧 Technical Details
Network Architecture

    Namespaces: Each subnet gets its own network namespace

    Virtual Bridges: Connect subnets within VPC

    veth Pairs: Virtual Ethernet pairs for namespace connectivity

    iptables/nftables: Firewall and NAT rules

Resource Naming Convention

    VPC: vpc-<name>

    Subnet: subnet-<vpc>-<name>

    Network Namespace: ns-<vpc>-<subnet>

    Bridge: br-<vpc>

    veth pair: veth-<src>-<dst>

Security Implementation

    Network Policies: Implemented via iptables/nftables

    Isolation: Complete namespace separation

    Stateful Filtering: Connection tracking support

    Logging: Rule hits logged for debugging

🐛 Troubleshooting
Common Issues

"Operation not permitted" errors:

    Run commands with sudo

    Ensure user has necessary capabilities

Network namespace not found:

    Check if setup.sh ran successfully

    Verify VPC/subnet exists with ./vpcctl list-vpcs

Connectivity issues:

    Check firewall rules are applied

    Verify routing tables in namespaces

    Ensure bridges are up and running

Debugging Commands
bash

# Check network namespaces
sudo ip netns list

# List bridges
sudo brctl show  # or ip link show type bridge

# Check iptables rules
sudo iptables -L -n -v

# Examine specific namespace
sudo ip netns exec ns-my-vpc-web ip addr show
sudo ip netns exec ns-my-vpc-web route -n

