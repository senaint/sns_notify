# Encrypting S3 Events sent to an SNS Topic

This module creates an S3 Bucket and SNS topics that sends notifications to supplied email for when a new file is uploaded to the S3 bucket.

NOTE: you must confirm your subscription via an automatically provided email link (post creation) prior to receiving notifications.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Required

* [Terraform](https://www.terraform.io/downloads.html)

## Recommended 

* [Terragrunt](https://github.com/gruntwork-io/terragrunt/releases)
* [TFlint](https://github.com/terraform-linters/tflint)

## Deploying
0) Install requirements and export AWS creds (i.e. run `aws configure`)
1) Clone Repo
2) `cd` in to the `sns_notify` directory
3) If using `Terraform`, update the `terraform.tfvars` file with your particular details
    - Run `terraform init` to pull dependecies
    - Run `terraform validate` and optionally run `tflint` to make sure your changes make sense
    - Run `terraform apply -var-file="terraform.tfvars"` to deploy
    - Run `chmod +x ./test.sh` to make it executable and then run `./test.sh`  
4) If using `Terragrunt`, update the input values in the `terragrunt.hcl` file.
    - Run `terragrunt validate` and optionally run `tflint` to sanity check
    - Run `terragrunt apply` to deploy

# Notes
* **Remote-State**: if you want remote state tracking with state-locking, uncomment the backend.tf file.
* **Tflint**: to use TFlint execute `tflint` in the module directory, for debugging use `TFLINT_LOG=debug tflint`
* **GH-actions**: the module also contains `tfsec` and `checkov` github action workflows to help make your terraform code more secure
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| email\_target | Subscriber Email | `string` | `"some-name"` | yes |
| bucket\_name | S3 Bucket Name | `string` | `"some-name"` | no |
| sns\_topic\_name | SNS Topic Name | `string` | `"some-name"` | no |
| sns\_topic\_name\_prefix | SNS Topic Name Prefix | `string` | `"some-name"` | no |
| tags | Tags to add to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Type |  
|------|-------------|------|
| sns\_topic\_arn | SNS Topic Identifier | `string` |
| bucket\_id | S3 Bucket Id | `string` | 
| email\_target | Subscriber Email | `string` | 


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
