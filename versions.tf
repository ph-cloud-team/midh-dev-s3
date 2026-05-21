terraform {
  required_version = ">= 1.6.0"
  backend "http" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

# Configure Terraform settings for this live root module.
# Require a modern Terraform version compatible with the platform pipeline image.
# Use GitLab HTTP state backend configured by the shared live pipeline at runtime.
# Declare providers used directly by this live root module.
# Declare the AWS provider because this root module configures AWS provider settings.
# Use the official HashiCorp AWS provider.
# Match the enterprise AWS provider major version used by the module platform.
