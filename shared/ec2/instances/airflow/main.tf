data "template_file" "launch_temp_user_data" {
  template = file("${path.module}/launch-temp.tpl")
}

module "ec2_instance" {
  source                  = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v5.0.0"
  name                    = "${local.service_name_prefix}-${local.workspace["ec2"]["name"]}"
  instance_type           = local.workspace["ec2"]["instance_type"]
  monitoring              = local.workspace["ec2"]["monitoring"]
  disable_api_termination = local.workspace["ec2"]["disable_api_termination"]
  key_name                = local.workspace["ec2"]["keyname"]
  vpc_security_group_ids  = [data.terraform_remote_state.security_group.outputs.airflow_sg]
  iam_instance_profile    = data.terraform_remote_state.iam_role.outputs.data_profile_name
  subnet_id               = data.aws_subnets.app_tools.ids[0]
  ami                     = data.aws_ami.latest_ubuntu.id
  tags                    = local.common_tags
  volume_tags             = local.common_tags
  user_data_base64        = base64encode(data.template_file.launch_temp_user_data.rendered)
  root_block_device = [{
    volume_type           = local.workspace["ec2"]["volume_type"]
    volume_size           = local.workspace["ec2"]["volume_size"]
    delete_on_termination = local.workspace["ec2"]["delete_on_termination"]
    encrypted             = local.workspace["ec2"]["encrypted"]
  }]
}
