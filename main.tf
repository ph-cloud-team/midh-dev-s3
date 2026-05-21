module "s3_bucket" {

  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/storage/tf-aws-s3-bucket.git?ref=v1.0.0"

  bucket_name_prefix = var.bucket_name_prefix

  access_logging = {
    target_bucket = var.access_log_bucket_name
    target_prefix = "${var.environment}/${var.application}/"
  }

  tags = {
    Name               = var.name
    Environment        = var.environment
    Owner              = var.owner
    CostCenter         = var.cost_center
    Application        = var.application
    DataClassification = var.data_classification
  }
}

# Temporary HTTP GitLab module source.
# This live repo consumes the certified tf-aws-s3-bucket module using an immutable semantic version tag.
# This is used because the current self-hosted GitLab environment is HTTP-only, and Terraform Registry discovery requires HTTPS.
# After GitLab HTTPS is enabled, switch back to the private Terraform Module Registry source:
# source  = "gitlab.midhtech.local/cloud_team/s3-bucket/aws"
# version = "1.0.0"
# Create the development S3 bucket by consuming the certified GitLab Terraform Module Registry package.
# Use the private GitLab Terraform Module Registry source published from tf-aws-s3-bucket.
# Pin the certified module version so live infrastructure changes are controlled and repeatable.
# Generate a globally unique bucket name from this enterprise-approved prefix.
# Send S3 server access logs to the central logging bucket managed outside this workload repo.
# Use a variable so each account or environment can provide its approved central access-log bucket.
# Store logs under an application/environment prefix for easier audit and lifecycle management.
# Apply enterprise tags required by source, plan, cost, ownership, and audit policies.
# TAGS: Name is required by enterprise naming and required-tag policies.
# Environment identifies the deployment tier such as dev, test, stage, or prod.
# Owner identifies the team accountable for the resource.
# CostCenter supports chargeback and cost allocation.
# Application identifies the workload using this bucket.
# DataClassification declares the sensitivity of data stored in the bucket.