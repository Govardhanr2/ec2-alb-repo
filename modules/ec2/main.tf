
resource "aws_instance" "web1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile   = var.instance_profile_name
    user_data = templatefile("${path.module}/user_data_web1.sh", {
    domain_name       = var.domain_name
    cloudwatch_config = var.cloudwatch_config_content
  })
  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_b_id
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile   = var.instance_profile_name
    user_data = templatefile("${path.module}/user_data_web2.sh", {
    domain_name       = var.domain_name
    cloudwatch_config = var.cloudwatch_config_content
  })
  tags = {
    Name = "web2"
  }
}
