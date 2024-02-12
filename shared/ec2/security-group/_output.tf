

output "jenkins_sg" {
  value = aws_security_group.jenkins_sg.id
}

output "data-validation_sg" {
  value = aws_security_group.data-validation_sg.id
}

output "airflow_sg" {
  value = aws_security_group.airflow_sg.id
}
