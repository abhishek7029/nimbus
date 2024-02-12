output "role_arn" {
  value = aws_iam_role.aws_role.arn
}

output "role_name" {
  value = aws_iam_role.aws_role.name
}

output "profile_name" {
  value = aws_iam_instance_profile.aws_profile.name
}

output "profile_arn" {
  value = aws_iam_instance_profile.aws_profile.arn
}