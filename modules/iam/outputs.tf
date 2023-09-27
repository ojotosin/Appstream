
# export appstream iam role arn
output "appstream_role_arn" {
  value = aws_iam_role.appstream_role.arn
}
