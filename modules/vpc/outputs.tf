# export the region
output "region" {
  value = var.region
}

# export the project name
output "project_name" {
  value = var.project_name
}

# export the environment
output "environment" {
  value = var.environment
}

# export the costcenter
output "costcenter" {
  value = var.costcenter
}

# export the createdby
output "createdby" {
  value = var.createdby
}

# export the data sensitivity
output "data_sensitivity" {
  value = var.data_sensitivity
}


# export the vpc id
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# export the internet gateway
output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

# export the public subnet az1 id
output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

# export the public subnet az2 id
output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

# export the private appstream subnet az1 id
output "private_appstream_subnet_az1_id" {
  value = aws_subnet.private_appstream_subnet_az1.id
}

# export the private appstream subnet az2 id
output "private_appstream_subnet_az2_id" {
  value = aws_subnet.private_appstream_subnet_az2.id
}


# export the first availability zone
output "availability_zone_1" {
  value = data.aws_availability_zones.available_zones.names[0]
}

# export the second availability zone
output "availability_zone_2" {
  value = data.aws_availability_zones.available_zones.names[1]
}

# export the vpc endpoint id
output "vpce_id" {
  value = aws_vpc_endpoint.appstream_endpoint.id
}