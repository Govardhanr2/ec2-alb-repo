
variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_a_id" {
  description = "The ID of public subnet A."
  type        = string
}

variable "public_subnet_b_id" {
  description = "The ID of public subnet B."
  type        = string
}

variable "alb_sg_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "web1_id" {
  description = "The ID of the first EC2 instance."
  type        = string
}

variable "web2_id" {
  description = "The ID of the second EC2 instance."
  type        = string
}

variable "domain_name" {
  description = "The root domain name for DNS and ACM."
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate."
  type        = string
}
