output "sns_topic_arn" {
  value = module.sns_topic.sns_topic_arn
}

output "bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}

output "email_id" {
  value = var.email_target
}