# export stack name
output "appstream_stack_name" {
  value = aws_appstream_stack.appstream_stack.name
}

# export stack arn
output "appstream_stack_arn" {
  value = aws_appstream_stack.appstream_stack.arn
}

# export fleet name
output "appstream_fleet_name" {
  value = aws_appstream_fleet.appstream_fleet.name
}

# export fleet id
output "appstream_fleet_id" {
  value = aws_appstream_fleet.appstream_fleet.id
}