variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "ami_id" {
  default = "ami-03f4878755434977f"
}

variable "domain_name" {
  description = "The root domain name for DNS and ACM."
  default     = "testpagespage.space"
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID."
  default     = "Z08515713LUCUHGGWXI83"
}
