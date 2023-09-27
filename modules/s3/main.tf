# create cloudtrail s3 bucket 
resource "aws_s3_bucket" "cloud_trail_bucket" {
  bucket = "${var.cloud_trail_bucket_name}"

  lifecycle {
    create_before_destroy = false
  }

}

# create cloudwatch s3 bucket
resource "aws_s3_bucket" "cloud_watch_bucket" {
  bucket = "${var.cloud_watch_bucket_name}"

  lifecycle {
    create_before_destroy = false
  }
}

# create appstream usage report s3 bucket
resource "aws_s3_bucket" "appstream_usage_report_bucket" {
  bucket = "${var.appstream_usage_report_s3_bucket_name}"

  lifecycle {
    create_before_destroy = false
  }
}

