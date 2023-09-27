# vpc variables
region                            = "us-east-1"
project_name                      = "COH-Appstream"
environment                       = "test"
costcenter                        = "CollegeofHealth"
owner                             = "ITS"
createdby                         = "TosinOjo"
data_sensitivity                  = "HighlyConfidential"
vpc_cidr                          = "10.196.224.0/22"
public_subnet_az1_cidr            = "10.196.224.0/24"
public_subnet_az2_cidr            = "10.196.225.0/24"
private_appstream_subnet_az1_cidr = "10.196.226.0/24"
private_appstream_subnet_az2_cidr = "10.196.227.0/24"

# NACL and security groups variables
ingress_cidr = ["0.0.0.0/0"] # 147.226.134.227/32


# appstream variables
appstream_image_name    = "CoHDemoImage-v1.0"
appstream_instance_type = "stream.standard.large"

# iam variables



# s3 bucket variables
cloud_trail_bucket_name               = "coh-test-cloudtrail-bucket"
cloud_watch_bucket_name               = "coh-test-cloudwatch-bucket"
appstream_usage_report_s3_bucket_name = "coh-test-appstream-usage-report-bucket"
