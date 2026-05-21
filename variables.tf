# Keep the type strict so invalid non-string values fail early.
# Explain that CI passes this from AWS_DEFAULT_REGION through TF_VAR_aws_region.
variable "aws_region" {
  type        = string
  description = "AWS region used by the live Terraform root module."
}

# Declare the S3 bucket name prefix used by the enterprise S3 module.
# Use a lowercase DNS-safe prefix that matches S3 naming standards.
variable "bucket_name_prefix" {
  type        = string
  description = "Prefix used by the S3 module to generate a globally unique bucket name."
  default     = "midh-dev-tf-testing-s3-"
}

# Declare the central access-log bucket name.
# Document that this bucket should already exist from the logging or account baseline stack.
variable "access_log_bucket_name" {
  type        = string
  description = "Existing central S3 access-log bucket that receives server access logs."
}

# Declare the enterprise Name tag.
# Use a lowercase hyphenated value that satisfies the enterprise naming policy.
variable "name" {
  type        = string
  description = "Enterprise Name tag applied to resources created by the S3 module."
  default     = "midh-dev-tf-testing-s3"
}

# Declare the environment tag.
# Explain that this value separates dev, test, stage, and prod resources.
variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "dev"
}

# Declare the owner tag.
# Default ownership to the platform team for this validation repo.
variable "owner" {
  type        = string
  description = "Owner tag value for the team accountable for this live stack."
  default     = "platform-team"
}

# Declare the cost center tag.
# Default to the shared services cost center for this validation repo.
variable "cost_center" {
  type        = string
  description = "Cost center tag value used for enterprise cost allocation."
  default     = "shared-services"
}

# Declare the application tag.
variable "application" {
  type        = string
  description = "Application tag value for the workload using this S3 bucket."
  default     = "test-shared-pipelines-images"
}

# Declare the data classification tag.
# Default to internal for platform validation data.
variable "data_classification" {
  type        = string
  description = "Data classification tag value for data stored in the S3 bucket."
  default     = "internal"
}
