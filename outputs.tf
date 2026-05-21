output "bucket_name" {
  description = "Name of the S3 bucket created by the enterprise S3 module."
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket created by the enterprise S3 module."
  value       = module.s3_bucket.bucket_arn
}

# Expose the KMS key ARN used by the module for S3 default encryption.
output "kms_key_arn" {
  description = "ARN of the KMS key used for S3 bucket encryption."
  value       = module.s3_bucket.kms_key_arn
}
