output "jenkins_role_arn" {
  value = module.ec2_jenkins_role.role_arn
}

output "jenkins_role_name" {
  value = module.ec2_jenkins_role.role_name
}

output "jenkins_profile_name" {
  value = module.ec2_jenkins_role.profile_name
}

output "jenkins_profile_arn" {
  value = module.ec2_jenkins_role.profile_arn
}

output "ssm_role_arn" {
  value = module.ec2_ssm_role.role_arn
}

output "ssm_role_name" {
  value = module.ec2_ssm_role.role_name
}

output "ssm_profile_name" {
  value = module.ec2_ssm_role.profile_name
}

output "ssm_profile_arn" {
  value = module.ec2_ssm_role.profile_arn
}
