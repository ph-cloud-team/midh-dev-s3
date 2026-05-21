provider "aws" {
  region = var.aws_region
}

# Configure the AWS provider in the live repository because reusable modules must not own provider configuration.
# Use the AWS region passed by GitLab CI/CD through TF_VAR_aws_region.