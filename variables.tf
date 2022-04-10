variable "region_name" {
  description = "Region Name"
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_name" {
  description = "SNS Topic Name"
  type        = string
  default     = "s3-newfile-notify"
}

variable "sns_topic_name_prefix" {
  description = "SNS Topic Name"
  type        = string
  default     = "s3-sns-notfication-topic"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
  default     = "s3-notify"
}

variable "email_target" {
  description = "Email Target"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to resources"
}