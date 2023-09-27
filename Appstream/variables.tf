# environment variables
variable "region" {}
variable "project_name" {}
variable "environment" {}
variable "owner" {}
variable "costcenter" {}
variable "createdby" {}
variable "data_sensitivity" {}

#vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_appstream_subnet_az1_cidr" {}
variable "private_appstream_subnet_az2_cidr" {}

# NACL and security groups variables
variable "ingress_cidr" {
  type = list(string)
}


# appstream variables
variable "appstream_instance_type" {}
variable "appstream_image_name" {}

# iam variables




# s3 variables
variable "cloud_trail_bucket_name" {}
variable "cloud_watch_bucket_name" {}
variable "appstream_usage_report_s3_bucket_name" {}