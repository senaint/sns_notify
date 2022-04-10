locals {
  bucket_name = "s3-bucket-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

/* terraform {
  backend "s3" {
    bucket = "${bucket_name}-tfstate"
    key    = "tfstates/${bucket_name}-tfstate"
    region = var.region_name
  }
} */

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name_prefix = try(var.sns_topic_name_prefix, "${random_pet.this.id}-2")

}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = module.sns_topic.sns_topic_arn
  protocol  = "email"
  endpoint  = var.email_target
}

resource "aws_sns_topic_policy" "policy" {
  arn    = module.sns_topic.sns_topic_arn
  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "${module.sns_topic.sns_topic_arn}",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${module.s3_bucket.s3_bucket_arn}"}
          }
      }]
  }
  POLICY
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.0.1"
  bucket        = var.bucket_name
  force_destroy = true
  depends_on    = [module.sns_topic]

}

resource "aws_s3_bucket_notification" "notif" {
  bucket     = module.s3_bucket.s3_bucket_id
  depends_on = [aws_sns_topic_policy.policy]

  topic {
    topic_arn = module.sns_topic.sns_topic_arn

    events = [
      "s3:ObjectCreated:*",
    ]
  }
}

resource "aws_kms_key" "topic_key" {
  description = "Topic Key"
  policy      = data.aws_iam_policy_document.topic_key_kms_policy.json
  tags        = var.tags

}

data "aws_iam_policy_document" "topic_key_kms_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [module.s3_bucket.s3_bucket_arn]
  }

  statement {
    effect = "Allow"
    principals {
      // Change this to some admin role, for example only
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}

