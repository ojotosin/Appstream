# export the appstream server security group id
output "appstream_security_group_id" {
  value = aws_security_group.appstream_security_group.id
}

# export the active directory security group id
output "active_directory_security_group" {
  value = aws_security_group.active_directory_security_group.id
}

# export the appstream security group for vpc endpoint id
output "appstream_vpc_endpoint_sg_id" {
  value = aws_security_group.appstream_vpc_endpoint_sg.id
}