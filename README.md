Windows Server Build with Terraform on Azure
Created by: Illanghkumaran Thiruvalluvan
Overview

This wiki provides comprehensive guidance for provisioning Windows Server virtual machines in Azure using Terraform Infrastructure as Code.

Quick Start
Prerequisites
powershell

# Install required tools (PowerShell as Administrator)
choco install terraform -y
choco install azure-cli -y
choco install git -y

# Verify installations
terraform --version
az --version
git --version

Initial Setup
powershell

# Clone repository
git clone https://dev.azure.com/your-project/terraform-windows-server
cd terraform-windows-server

# Azure login
az login
az account set --subscription "your-subscription-id"

# Initialize Terraform
terraform init

Repository Structure
text

terraform-windows-server/
├── main.tf                 # Main configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars.example # Example variables
├── provider.tf             # Provider configuration
├── versions.tf             # Version constraints
├── modules/
│   └── windows-vm/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
