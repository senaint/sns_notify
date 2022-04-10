# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
terraform {
  source = "../sns-events"
  after_hook "test" {
    commands = ["apply"]
    execute  = ["bash", "-c", "./test"]
  }
}

locals {
  region_name = "us-east-1"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents = file("../sns-events/provider.tf")
}
# Indicate the input values to use for the variables of the module.
inputs = {
  aws_sns_topic = "s3-newfile-notify"
  region_name = local.region_name
  /* bucket_name = local.bucket_name
  sns_topic_name_prefix = "${random_pet.this.id}-2" */
  email_target = "senaint@gmail.com"
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

