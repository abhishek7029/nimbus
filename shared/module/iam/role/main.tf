resource "aws_iam_role" "aws_role" {
  name                 = "${var.role_name}-role"
  description          = var.role_description
  max_session_duration = var.max_session_duration
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "${var.assume_role}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(var.common_tags, tomap({ "Name" : "${var.role_name}-role" }))
}

resource "aws_iam_instance_profile" "aws_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.aws_role.name
}
