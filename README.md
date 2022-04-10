# Encrypting S3 Events sent to an SNS Topic

This module creates an example of an S3 Bucket and sends notifications for created files to 
an SNS topic that is encrypted using KMS.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | S3 Bucket Name | `string` | `"some-name"` | no |
| sns\_topic\_name | SNS Topic Name | `string` | `"some-name"` | no |
| tags | Tags to add to resources | `map(string)` | `{}` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
