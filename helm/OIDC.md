# GitHub Actions OIDC Setup for AWS EKS Deployment

## Overview

This document shows how to deploy the Helm chart to a staging EKS cluster using GitHub Actions with OIDC authentication (no AWS access keys needed).

## Prerequisites

- AWS Account with EKS cluster
- GitHub repository
- AWS IAM permissions to create roles

## Step 1: Create OIDC Identity Provider in AWS

```bash
# Get GitHub OIDC thumbprint
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

## Step 2: Create IAM Role for GitHub Actions

```bash
# Create trust policy file
cat > github-oidc-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_ORG/YOUR_REPO:*"
        }
      }
    }
  ]
}
EOF

# Create IAM role
aws iam create-role \
  --role-name GitHubActionsEKSRole \
  --assume-role-policy-document file://github-oidc-trust-policy.json

# Attach EKS permissions
aws iam attach-role-policy \
  --role-name GitHubActionsEKSRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

aws iam attach-role-policy \
  --role-name GitHubActionsEKSRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
```

## Step 3: GitHub Actions Workflow

Create `.github/workflows/deploy-staging.yml`:

```yaml
name: Deploy to Staging EKS

on:
  push:
    branches:
      - main
    paths:
      - 'helm/nginx-app/**'
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    name: Deploy Helm Chart to Staging
    runs-on: ubuntu-latest
    environment: staging

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials using OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/GitHubActionsEKSRole
          aws-region: us-east-1

      - name: Install kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'v1.28.0'

      - name: Install Helm
        uses: azure/setup-helm@v3
        with:
          version: 'v3.13.0'

      - name: Update kubeconfig for EKS
        run: |
          aws eks update-kubeconfig \
            --name staging-eks-cluster \
            --region us-east-1

      - name: Verify cluster access
        run: |
          kubectl cluster-info
          kubectl get nodes

      - name: Deploy Helm chart
        run: |
          helm upgrade --install nginx-app ./helm/nginx-app \
            --namespace staging \
            --create-namespace \
            --values ./helm/nginx-app/values.yaml \
            --wait \
            --timeout 5m

      - name: Verify deployment
        run: |
          kubectl get pods -n staging
          kubectl get svc -n staging
          kubectl get ingress -n staging
```

## Step 4: Configure GitHub Repository

Add these secrets/variables in GitHub repository settings:

- **AWS_REGION**: `us-east-1`
- **EKS_CLUSTER_NAME**: `staging-eks-cluster`
- **AWS_ROLE_ARN**: `arn:aws:iam::ACCOUNT_ID:role/GitHubActionsEKSRole`

## How It Works

1. GitHub Actions requests a token from GitHub's OIDC provider
2. GitHub provides a JWT token with repository information
3. AWS STS validates the token against the IAM role trust policy
4. AWS returns temporary credentials (valid for 1 hour)
5. GitHub Actions uses these credentials to access EKS
6. Helm deploys the chart to the staging cluster

## Benefits of OIDC

- No long-lived AWS credentials in GitHub
- Automatic credential rotation
- Fine-grained access control
- Audit trail in CloudTrail
- More secure than access keys

## Testing Locally

To test the Helm deployment locally:

```bash
# Configure kubectl for EKS
aws eks update-kubeconfig --name staging-eks-cluster --region us-east-1

# Test Helm template
helm template nginx-app ./helm/nginx-app

# Deploy to staging
helm upgrade --install nginx-app ./helm/nginx-app \
  --namespace staging \
  --create-namespace \
  --values ./helm/nginx-app/values.yaml \
  --dry-run --debug

# Actual deployment
helm upgrade --install nginx-app ./helm/nginx-app \
  --namespace staging \
  --create-namespace \
  --values ./helm/nginx-app/values.yaml
```
