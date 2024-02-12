data "template_file" "policy_ops_jenkins" {
  template = file("${path.module}/policy-files/jenkins-policy.tpl")
}

resource "aws_iam_policy" "jenkins_policy" {
  name        = "${local.service_name_prefix}-jenkins-policy"
  path        = local.workspace["iam"]["path"]
  description = "${local.service_name_prefix}-jenkins-policy"
  policy      = data.template_file.policy_ops_jenkins.rendered
  tags        = merge(local.common_tags, tomap({ "Name" : "${local.service_name_prefix}-jenkins-policy" }))
}

module "ec2_jenkins_role" {
  source           = "../module/iam/role"
  role_name        = "${local.service_name_prefix}-jenkins"
  role_description = "Jenkins EC2 role access"
  assume_role      = "ec2.amazonaws.com"
  common_tags      = local.common_tags
}

resource "aws_iam_role_policy_attachment" "jenkins_ssm_managed_instance_core_policy" {
  role       = module.ec2_jenkins_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "jenkins_cloudwatch_agent_server_policy" {
  role       = module.ec2_jenkins_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "jenkins_cloudwatch_agent_admin_policy" {
  role       = module.ec2_jenkins_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_policy_attachment1" {
  role       = module.ec2_jenkins_role.role_name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}
