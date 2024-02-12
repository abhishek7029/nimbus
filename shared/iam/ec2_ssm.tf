module "ec2_ssm_role" {
  source           = "../module/iam/role"
  role_name        = "${local.service_name_prefix}-ssm"
  role_description = "Basic EC2 role access"
  assume_role      = "ec2.amazonaws.com"
  common_tags      = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_managed_instance_core_policy" {
  role       = module.ec2_ssm_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_agent_server_policy" {
  role       = module.ec2_ssm_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_agent_admin_policy" {
  role       = module.ec2_ssm_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

###### SSM parameter policy creation and attachment  

data "template_file" "policy_ssm_parameter" {
  template = file("${path.module}/policy-files/ssm-parameter-policy.tpl")
}

resource "aws_iam_policy" "ssm_parameter_policy" {
  name   = "${local.service_name_prefix}-ssm-parameter-policy"
  policy = data.template_file.policy_ssm_parameter.rendered
}

resource "aws_iam_role_policy_attachment" "ssm_parameter_policy_attachment" {
  role       = module.ec2_ssm_role.role_name
  policy_arn = aws_iam_policy.ssm_parameter_policy.arn
}