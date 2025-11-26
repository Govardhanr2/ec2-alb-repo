output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "cloudwatch_config_content" {
  value = file("${path.module}/config.json")
}
