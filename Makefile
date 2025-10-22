.PHONY: help deploy-backend deploy-packer deploy-infra \
        destroy-infra destroy-backend destroy-all \
        clean format lint validate-all status outputs

# Variables
PACKER_DIR = packer
TERRAFORM_DIR = infra/ec2-nginx
BACKEND_DIR = infra/backend-setup
PACKER_FILE = nginx-ami.pkr.hcl
PACKER_VARS = variables.pkrvars.hcl

help: ## Show this help message
	@echo '╔════════════════════════════════════════════════════════════════╗'
	@echo '║         DevOps Project - EC2 Nginx Application                 ║'
	@echo '╚════════════════════════════════════════════════════════════════╝'
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'
	@echo ''
	@echo 'Deployment Order:'
	@echo '  1. make deploy-backend     - Create S3 & DynamoDB for state'
	@echo '  2. make deploy-packer      - Build AMI'
	@echo '  3. make deploy-infra       - Deploy infrastructure'
	@echo ''
	@echo 'Cleanup:'
	@echo '  make destroy-infra         - Destroy infrastructure only'
	@echo '  make destroy-backend       - Destroy backend only'
	@echo '  make destroy-all           - Destroy everything (infra + backend)'
	@echo ''

# ============================================================================
# Backend Setup (S3 + DynamoDB for Terraform state)
# ============================================================================

deploy-backend: ## Deploy backend (S3 + DynamoDB + VPC Flow Logs bucket)
	@echo "Deploying backend resources..."
	cd $(BACKEND_DIR) && terraform init
	cd $(BACKEND_DIR) && terraform validate
	cd $(BACKEND_DIR) && terraform plan
	cd $(BACKEND_DIR) && terraform apply
	@echo "Backend deployed!"
	@echo ""
	@echo "Copy these outputs to terraform.tfvars:"
	cd $(BACKEND_DIR) && terraform output vpc_flow_logs_bucket_arn

# ============================================================================
# Packer (AMI Building)
# ============================================================================

deploy-packer: ## Build AMI with Packer
	@echo "Building AMI..."
	cd $(PACKER_DIR) && packer init $(PACKER_FILE)
	cd $(PACKER_DIR) && packer validate -var-file=$(PACKER_VARS) $(PACKER_FILE)
	cd $(PACKER_DIR) && packer build -var-file=$(PACKER_VARS) $(PACKER_FILE)
	@echo "AMI build complete!"
	@echo ""
	@echo "Copy the AMI ID from above and update infra/ec2-nginx/terraform.tfvars"

# ============================================================================
# Infrastructure Deployment
# ============================================================================

deploy-infra: ## Deploy infrastructure (VPC + ALB + ASG + EC2)
	@echo "Deploying infrastructure..."
	cd $(TERRAFORM_DIR) && terraform init
	cd $(TERRAFORM_DIR) && terraform validate
	cd $(TERRAFORM_DIR) && terraform plan
	cd $(TERRAFORM_DIR) && terraform apply
	@echo "Infrastructure deployed!"
	@echo ""
	@echo "Access your application:"
	cd $(TERRAFORM_DIR) && terraform output alb_url

# ============================================================================
# Destroy
# ============================================================================

destroy-infra: ## Destroy infrastructure only
	@echo "WARNING: This will destroy infrastructure!"
	cd $(TERRAFORM_DIR) && terraform destroy

destroy-backend: ## Destroy backend (S3 + DynamoDB + VPC Flow Logs bucket)
	@echo "WARNING: This will destroy backend resources!"
	@echo "Make sure you've destroyed infrastructure first!"
	cd $(BACKEND_DIR) && terraform destroy

destroy-all: destroy-infra destroy-backend ## Destroy everything (infra + backend)
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║              ALL RESOURCES DESTROYED!                          ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"

# ============================================================================
# Utilities
# ============================================================================

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	find . -name "*.retry" -delete
	find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "terraform.tfstate*" -delete
	find . -name "manifest.json" -delete
	find . -name "packer_cache" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleanup complete!"

format: ## Format Terraform and Packer files
	@echo "Formatting code..."
	cd $(TERRAFORM_DIR) && terraform fmt -recursive
	cd $(BACKEND_DIR) && terraform fmt -recursive
	cd $(PACKER_DIR) && packer fmt .
	@echo "Formatting complete!"

lint: ## Lint Ansible playbooks
	@echo "Linting Ansible playbooks..."
	cd $(PACKER_DIR)/ansible && ansible-lint pack-playbook.yml fry-playbook.yml || true

validate-all: ## Validate all configurations
	@echo "Validating all configurations..."
	cd $(BACKEND_DIR) && terraform validate || true
	cd $(PACKER_DIR) && packer validate -var-file=$(PACKER_VARS) $(PACKER_FILE) || true
	cd $(TERRAFORM_DIR) && terraform validate || true
	@echo "Validation complete!"

# ============================================================================
# Status & Info
# ============================================================================

status: ## Show deployment status
	@echo "Deployment Status:"
	@echo ""
	@echo "Backend Setup:"
	@cd $(BACKEND_DIR) && terraform show 2>/dev/null | head -5 || echo "  Not initialized"
	@echo ""
	@echo "Infrastructure:"
	@cd $(TERRAFORM_DIR) && terraform show 2>/dev/null | head -5 || echo "  Not initialized"

outputs: ## Show all Terraform outputs
	cd $(TERRAFORM_DIR) && terraform output
