# create security group to appstream fleet from vpc endpoints
resource "aws_security_group" "appstream_vpc_endpoint_sg" {
  name        = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream-vpc-endpoint_sg"
  description = "Allows connection to AppStream via VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #TODO: restrict to vpc endpoints
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream_sg"
  }
}


# create security group for the appstream fleet instances
resource "aws_security_group" "appstream_security_group" {
  name        = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream-admin-sg"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = var.ingress_cidr
  }

  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = var.ingress_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-appstream-admin-sg"
  }
}

# create security group for Active Directory server
resource "aws_security_group" "active_directory_security_group" {
  name        = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-active-directory-sg"
  description = "allows RDP access (port 3389) for AD servers to the appstream fleet instances" # TODO: restrict to appstream fleet instances
  vpc_id      = var.vpc_id

  ingress {
    description     = "RDP access"
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    security_groups = [aws_security_group.appstream_security_group.id, aws_security_group.appstream_vpc_endpoint_sg.id] # TODO: restrict to active directory servers
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.costcenter}-${var.createdby}-${var.data_sensitivity}-active-directory_sg"
  }
}