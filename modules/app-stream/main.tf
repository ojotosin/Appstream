/*
# create the image builder to create the image for the fleet
resource "aws_appstream_image_builder" "appstream_image_builder" {
  name = "${var.project_name}-${var.environment}-${var.owner}-coh-appstream-image-builder"
  description = "AppStream image builder for ${var.project_name}-${var.environment}-${var.owner}"
  display_name = "${var.project_name}-${var.environment}-${var.owner}-coh-appstream-image-builder"
  image_name = "AppStream-WinServer2019-03-29-2023"
  instance_type = "stream.standard.large"
  vpc_config {
    subnet_ids = [var.private_appstream_subnet_az1_id]
    security_group_ids = var.security_group_ids
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-coh-appstream-image-builder"
  }
}
*/

# creates the stack to logically group settings and configurations for the AppStream applications and users
resource "aws_appstream_stack" "appstream_stack" {
  name = "${var.project_name}-${var.environment}-${var.owner}-appstream-stack"
  display_name = "${var.project_name}-${var.environment}-${var.owner}-appstream-stack"
  description = "AppStream stack for ${var.project_name}-${var.environment}-${var.owner}"
 /* 
  access_endpoints {
    endpoint_type = "STREAMING"
    vpce_id = var.vpce_id
  }
  */
  # Enable persistent application settings for users to save application customization after each session ends
  application_settings {
    enabled = true
    settings_group = "default"
  }

  # Stack storage for a home folder in s3
  storage_connectors {
      connector_type = "HOMEFOLDERS"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream-stack"
  }
}


# creates the fleet to provision the instances to run the AppStream applications
resource "aws_appstream_fleet" "appstream_fleet" {
  name = "${var.project_name}-${var.environment}-${var.owner}-appstream-fleet"
  display_name = "${var.project_name}-${var.environment}-${var.owner}-appstream-fleet"
  description = "AppStream fleet for ${var.project_name}-${var.environment}-${var.owner}"
  compute_capacity {
    desired_instances = 3
  }
  image_name                     = var.appstream_image_name
  instance_type                  = var.appstream_instance_type
  fleet_type                     = "ON_DEMAND"
  stream_view                    = "APP"
  enable_default_internet_access = false
  idle_disconnect_timeout_in_seconds = 60 
  
  # Ensures the fleet is in the private subnets and uses a security group that allows traffic from the ALB
  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = var.security_group_ids
  }

  # specify the IAM role that allows AppStream 2.0 to access your applications and storage
  iam_role_arn = var.iam_role_arn


  # TODO: This is the domain join info for the directory service to join later
  /*
  domain_join_info {
    directory_name = aws_directory_service_directory.ad.name # TODO: This is the name of the directory service to join later
    organizational_unit_distinguished_name = "OU=AppStream,DC=corp,DC=example,DC=com"
  }
    */
  //depends_on = [ aws_appstream_image_builder.appstream_image_builder ]

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream-fleet"
  }
}


# creates the association between the stack and the fleet
resource "aws_appstream_fleet_stack_association" "stack_fleet_association" {
  fleet_name = aws_appstream_fleet.appstream_fleet.name
  stack_name = aws_appstream_stack.appstream_stack.name
}


/*
# create a target group attachment for each appstream instances
resource "aws_lb_target_group_attachment" "appstream_target_group_attachment" {
  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
 for_each = {
    for instance in aws_appstream_fleet.appstream_fleet.instances :
    instance.id => instance
  }

  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = each.value.id
  port             = 80
}
*/

# Create CloudWatch log group for the fleet
resource "aws_cloudwatch_log_group" "appstream_fleet_log_group" {
  name = "/aws/appstream/${var.project_name}-${var.environment}-${var.owner}-fleet"
  retention_in_days = 30
}

# Create CloudWatch log group for the stack
resource "aws_cloudwatch_log_group" "appstream_stack_log_group" {
  name = "/aws/appstream/${var.project_name}-${var.environment}-${var.owner}-stack"
  retention_in_days = 30
}









