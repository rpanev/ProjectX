# ProjectX - EC2 Nginx Application

Infrastructure as Code project using Packer, Ansible, Terraform, and Terragrunt to deploy a scalable Nginx application on AWS.

## Architecture

- **Packer**: Builds AMI with Nginx (Pack/Fry pattern)
- **Ansible**: Configures Nginx and runtime scripts
- **Terraform**: Provisions AWS infrastructure (VPC, ALB, ASG, etc.)
- **Terragrunt**: DRY wrapper for Terraform configurations
- **Helm**: Kubernetes deployment charts (optional)

## Project Structure

```
DevOps-Project/
├── packer/              # AMI building with Packer
│   ├── nginx-ami.pkr.hcl
│   └── ansible/         # Ansible roles (pack/fry)
├── infra/               # Terraform modules
│   ├── backend-setup/   # S3 + DynamoDB backend
│   ├── ec2-nginx/       # Main infrastructure
│   └── modules/         # Reusable modules
├── helm/                # Helm charts for Kubernetes
│   └── nginx-app/
└── Makefile             # Deployment automation
```

## Prerequisites

- AWS CLI configured
- Packer >= 1.9.0
- Terraform >= 1.5.0
- Ansible >= 2.14
- AWS Session Manager Plugin (for SSH-less access)

## Quick Start

### Step 1: Deploy Backend

Create S3 bucket and DynamoDB table for Terraform state:

```bash
make deploy-backend
```

### Step 2: Build AMI

Build custom AMI with Nginx using Packer:

```bash
make deploy-packer
```

### Step 3: Deploy Infrastructure

Deploy VPC, ALB, ASG, and EC2 instances:

```bash
make deploy-infra
```

## AWS Session Manager Plugin

### Installation

#### Rocky Linux / AlmaLinux / RHEL

```bash
# Download
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" \
  -o "session-manager-plugin.rpm"

# Install
sudo dnf install -y session-manager-plugin.rpm

# Verify
session-manager-plugin
```

#### macOS

```bash
# Download
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" \
  -o "sessionmanager-bundle.zip"

# Extract
unzip sessionmanager-bundle.zip

# Install
sudo ./sessionmanager-bundle/install \
  -i /usr/local/sessionmanagerplugin \
  -b /usr/local/bin/session-manager-plugin

# Verify
session-manager-plugin
```

## Instance Management

### Connect to Instance

```bash
# Get instance ID
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=nginx-app-*" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text

# Connect via SSM
aws ssm start-session --target i-INSTANCE_ID
```

### Check Services

```bash
# Check nginx service
sudo systemctl status nginx

# Check fry-config service
sudo systemctl status fry-config

# Verify services are enabled
sudo systemctl is-enabled nginx
sudo systemctl is-enabled fry-config
```

### View Logs

```bash
# Nginx logs
sudo journalctl -u nginx -n 50 --no-pager

# Fry-config logs
sudo journalctl -u fry-config -n 50 --no-pager

# All logs
sudo journalctl -u nginx -u fry-config -n 100 --no-pager
```

## Accessing the Application

After deployment, get the ALB DNS name:

```bash
# Get ALB URL
terraform output -raw alb_url

# Or via AWS CLI
aws elbv2 describe-load-balancers \
  --names nginx-app-alb \
  --query "LoadBalancers[0].DNSName" \
  --output text
```

Access the application:
```
http://ALB_DNS_NAME
```

## Infrastructure Components

- **VPC**: 10.0.0.0/16 with public and private subnets
- **ALB**: Application Load Balancer in public subnets
- **ASG**: Auto Scaling Group (2-4 instances) in private subnets
- **EC2**: t3.micro instances with custom Nginx AMI
- **Security Groups**: ALB (80/443) and EC2 (80, 22 optional)
- **IAM**: Instance profile with SSM and S3 permissions

## Auto Scaling

Scales based on CPU utilization:
- **Target**: 70% CPU
- **Min**: 2 instances
- **Max**: 4 instances
- **Desired**: 2 instances

## Security

- Instances in private subnets (no public IPs)
- SSH access via AWS Systems Manager (no SSH keys needed)
- Security groups with least privilege
- Encrypted S3 buckets for state and logs
- IAM roles with minimal permissions

## Troubleshooting

### Check ALB Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

### Check ASG Status

```bash
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names nginx-app-asg
```

## Cleanup

```bash
# Destroy infrastructure
make destroy-infra

# Destroy backend (careful!)
make destroy-backend

```

## Documentation

- [Packer README](packer/README.md) - AMI building details
- [Terraform Modules](infra/modules/) - Module documentation
- [Helm Charts](helm/README.md) - Kubernetes deployment

## License

This project is for educational purposes.