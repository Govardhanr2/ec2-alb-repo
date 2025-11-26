variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances."
  type        = string
}

variable "private_subnet_a_id" {
  description = "The ID of the private subnet for the first EC2 instance."
  type        = string
}

variable "private_subnet_b_id" {
  description = "The ID of the private subnet for the second EC2 instance."
  type        = string
}

variable "ec2_sg_id" {
  description = "The ID of the security group for the EC2 instances."
  type        = string
}

variable "domain_name" {
  description = "The domain name."
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the EC2 instances."
  type        = string
}

variable "cloudwatch_config_content" {
  description = "The content of the CloudWatch agent configuration file."
  type        = string
}
