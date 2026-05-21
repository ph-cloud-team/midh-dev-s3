# test-shared-pipelines-images



Enterprise Terraform live repository used to validate the shared AWS live pipeline with a real S3 bucket deployment.

## Architecture

This repository follows the enterprise module-only pattern:

```text
GitLab CI/CD
  -> platform-pipelines/terraform/live/aws.yml
  -> GitLab HTTP Terraform state backend
  -> GitLab Terraform Module Registry
  -> tf-aws-s3-bucket module
  -> AWS S3 bucket, KMS encryption, versioning, logging, lifecycle, public access block
```

The live repo owns only Terraform backend configuration, AWS provider configuration, environment-specific variables, module composition, and outputs needed by operators or downstream automation.

The live repo does not create raw AWS resources directly. Raw resources belong inside approved module repositories.

## Module

The S3 bucket is created through the certified module registry package:

```hcl
module "s3_bucket" {
  source  = "gitlab.midhtech.local/cloud_team/s3-bucket/aws"
  version = "1.0.0"
}
```

Update `version` only after a new `tf-aws-s3-bucket` module version has passed the module pipeline and has been published to the GitLab Terraform Module Registry.

## Pipeline

The local `.gitlab-ci.yml` only includes the shared live pipeline:

```yaml
include:
  - project: infra_team/platform-pipelines
    ref: main
    file: terraform/live/aws.yml
```

The shared pipeline owns Gitleaks, Checkov, TFLint, Terraform validation, Terraform plan, OPA/Conftest source policies, OPA/Conftest plan policies, manual apply, and controlled destroy.

## Required CI/CD Variables

Configure these in GitLab CI/CD variables for this live repo:

| Variable | Purpose |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | AWS access key used by Terraform pipeline jobs |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key used by Terraform pipeline jobs |
| `AWS_DEFAULT_REGION` | AWS region used by the provider and `TF_VAR_aws_region` |
| `TF_HTTP_USERNAME` | GitLab Terraform HTTP backend username |
| `TF_HTTP_PASSWORD` | GitLab Terraform HTTP backend password or token |
| `TF_VAR_access_log_bucket_name` | Existing central S3 access-log bucket name |

The pipeline maps:

```text
AWS_DEFAULT_REGION -> TF_VAR_aws_region -> var.aws_region
```

## Terraform Files

| File | Responsibility |
| --- | --- |
| `.gitlab-ci.yml` | Includes the shared enterprise live AWS pipeline |
| `versions.tf` | Defines Terraform version, GitLab HTTP backend, and AWS provider requirement |
| `main.tf` | Configures AWS provider and consumes the S3 bucket module |
| `variables.tf` | Defines environment inputs and enterprise tag values |
| `outputs.tf` | Exposes bucket and KMS outputs from the module |

## Deployment Flow

1. Push changes to a branch.
2. GitLab runs source validation, static scans, linting, formatting, validation, plan, and plan policies.
3. Merge to `main` after the pipeline passes.
4. Run the manual `apply` job from `main`.
5. Terraform applies the previously generated plan using GitLab HTTP state.

## Destroy Flow

Destroy is controlled by the shared live pipeline and requires:

```text
ALLOW_DESTROY=true
CHANGE_TICKET_ID=<approved-change-ticket>
```

Destroy is manual and available only through the protected shared pipeline workflow.
