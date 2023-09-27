# output appstream usage report s3 bucket name arn
output "appstream_usage_report_s3_bucket_arn" {
  value = aws_s3_bucket.appstream_usage_report_bucket.arn
}

# output appstream usage report s3 bucket name
output "appstream_usage_report_s3_bucket_name" {
  value = aws_s3_bucket.appstream_usage_report_bucket.id
}