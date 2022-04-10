# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "../sns_notify"
  after_hook "Run Validation Test" {
    commands = ["apply"]
    execute  = ["bash", "-c", "./test.sh"]
  }
}

locals {
  region_name = "us-east-1"
  email_id    = "your_email@gmail.com"
  bucket_name = "s3-sns-fileupload-email-notifier-bucket"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents = file("../sns_notify/provider.tf")
}
# Indicate the input values to use for the variables of the module.
inputs = {
  aws_sns_topic = "s3-newfile-notify"
  region_name = local.region_name
  bucket_name = local.bucket_name 
  email_target = local.email_id
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

