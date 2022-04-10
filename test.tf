resource "time_sleep" "wait_30_seconds" {
    count = var.test ? 1 : 0
    depends_on = [aws_s3_bucket_notification.notif]
    create_duration = "30s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "health_check" {
    depends_on = [time_sleep.wait_30_seconds]
    count = var.test ? 1 : 0

 provisioner "local-exec" {

    command = "/bin/bash test.sh"
  }
}