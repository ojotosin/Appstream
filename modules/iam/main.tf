# Create an IAM role for managing AppStream fleets
resource "aws_iam_role" "appstream_role" {
  name               = "${var.project_name}-${var.environment}-${var.owner}-appstream_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "appstream.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary policies to the AppStream fleet role
resource "aws_iam_role_policy_attachment" "appstream_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAppStreamServiceAccess"
  role       = aws_iam_role.appstream_role.name
}

# Attach S3 Full Access policy to the IAM role
resource "aws_iam_role_policy_attachment" "appstream_s3_full_access" {
  role       = aws_iam_role.appstream_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "appstream_log_group" {
  name = "${var.project_name}-${var.environment}-${var.owner}-appstream_log_group"
}

# Create a CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "appstream_log_stream" {
  name           = "${var.project_name}-${var.environment}-${var.owner}-appstream_log_stream"
  log_group_name = aws_cloudwatch_log_group.appstream_log_group.name
}

# AWS Config setup
resource "aws_config_configuration_recorder" "recorder" {
  name     = "${var.project_name}-${var.environment}-${var.owner}-recorder"
  role_arn = aws_iam_role.appstream_role.arn

  recording_group {
    all_supported               = true
    include_global_resource_types = true
  }
}

# Enable the Config rule for CloudTrail
resource "aws_config_config_rule" "cloudtrail_config_rule" {
  name = "${var.project_name}-${var.environment}-${var.owner}-cloudtrail-config-rule"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.recorder]
}


/*
# CloudTrail setup
resource "aws_cloudtrail" "cloud_trail" {
  name                          = "${var.project_name}-${var.environment}-${var.owner}-cloud_trail"
  s3_bucket_name                = "${var.cloud_trail_bucket_name}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = true

  depends_on = [aws_iam_role_policy_attachment.appstream_s3_full_access]
}

*/

# IAM policy for CloudWatch logs
resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "${var.project_name}-${var.environment}-${var.owner}-cloudwatch_policy"
  path        = "/"
  description = "IAM policy for CloudWatch logs"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource": "${aws_cloudwatch_log_group.appstream_log_group.arn}"
      }
    ]
  }
  EOF
}


# Attach the CloudWatch logs policy to the IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.appstream_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}


# create a role for users to access appstream
resource "aws_iam_role" "appstream_user_access_role" {
  name               = "${var.project_name}-${var.environment}-${var.owner}-appstream_user_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "appstream.amazonaws.com"
        }
      }
    ]
  })
}

# create a stream only policy for users to access appstream
 resource "aws_iam_policy" "appstream_user_policy" {
  name        = "${var.project_name}-${var.environment}-${var.owner}-appstream_user_access_policy"
  path        = "/"
  description = "IAM policy for AppStream users"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "appstream:Stream*",
        ]
        Effect   = "Allow"
        Resource = var.appstream_stack_arn
      },
    ]
  })
}

# attach the policy to the role
resource "aws_iam_role_policy_attachment" "appstream_user_policy_attachment" {
  role       = aws_iam_role.appstream_user_access_role.name
  policy_arn = aws_iam_policy.appstream_user_policy.arn
}


/* 
# set up a trust relationship between the role and the user (TODO: to be configured for the identity provider XML file)
resource "aws_iam_saml_provider" "saml_provider" {
  name = "${var.project_name}-${var.environment}-${var.owner}-saml_provider"
  saml_metadata_document = <<EOF
*/