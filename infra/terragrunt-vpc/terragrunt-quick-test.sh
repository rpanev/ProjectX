#!/bin/bash

# Script for testing VPC module with VPC Endpoints - DEV Environment

set -e

REGION="eu-west-1"
ENV="dev"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/env/${ENV}"

COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m'

echo -e "${COLOR_BLUE}========================================${COLOR_RESET}"
echo -e "${COLOR_BLUE}  VPC Module Test Script - ${COLOR_YELLOW}${ENV}${COLOR_BLUE} Environment${COLOR_RESET}"
echo -e "${COLOR_BLUE}========================================${COLOR_RESET}"
echo ""

# Function to print step
print_step() {
    echo -e "${COLOR_GREEN}>>> $1${COLOR_RESET}"
}

# Function to print error
print_error() {
    echo -e "${COLOR_RED}ERROR: $1${COLOR_RESET}"
}

# Check if terragrunt is installed
if ! command -v terragrunt &> /dev/null; then
    print_error "Terragrunt is not installed. Please install it first."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if env directory exists
if [ ! -d "$ENV_DIR" ]; then
    print_error "Environment directory not found: $ENV_DIR"
    exit 1
fi

# Change to environment directory
cd "$ENV_DIR"
echo "Working directory: $ENV_DIR"
echo ""

# Step 1: Initialize
print_step "Step 1: Initializing Terragrunt for ${ENV}..."
terragrunt init

# Step 2: Plan
print_step "Step 2: Running Terragrunt plan for ${ENV}..."
terragrunt plan -out=tfplan

# Step 3: Ask for confirmation
echo ""
read -p "Do you want to apply the plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

# Step 4: Apply
print_step "Step 3: Applying Terragrunt configuration for ${ENV}..."
terragrunt apply tfplan

# Step 5: Get outputs
print_step "Step 4: Getting outputs for ${ENV}..."
VPC_ID=$(terragrunt output -raw vpc_id)
echo "Environment: ${ENV}"
echo "VPC ID: $VPC_ID"

# Step 6: Verify VPC Endpoints
print_step "Step 5: Verifying VPC Endpoints..."
echo ""
echo "All VPC Endpoints:"
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $REGION \
  --query 'VpcEndpoints[*].[VpcEndpointId,ServiceName,State,VpcEndpointType]' \
  --output table

echo ""
echo "S3 Gateway Endpoint:"
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=service-name,Values=com.amazonaws.$REGION.s3" \
  --region $REGION \
  --query 'VpcEndpoints[0].[VpcEndpointId,State,VpcEndpointType]' \
  --output table

echo ""
echo "SSM Interface Endpoints:"
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=service-name,Values=*ssm*" \
  --region $REGION \
  --query 'VpcEndpoints[*].[VpcEndpointId,ServiceName,State]' \
  --output table

# Step 7: Check Route Tables
print_step "Step 6: Checking Route Tables..."
echo ""
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $REGION \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0],Routes[?GatewayId!=`local`].GatewayId|[0]]' \
  --output table

echo ""
echo -e "${COLOR_GREEN}========================================${COLOR_RESET}"
echo -e "${COLOR_GREEN}  Test completed successfully for ${ENV}!${COLOR_RESET}"
echo -e "${COLOR_GREEN}========================================${COLOR_RESET}"
echo ""
echo "To destroy the ${ENV} environment, run:"
echo "  cd ${ENV_DIR}"
echo "  terragrunt destroy"
