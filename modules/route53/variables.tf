
variable "domain_name" {
  description = "The root domain name for DNS and ACM."
  type        = string
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID."
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB."
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the ALB."
  type        = string
}

variable "domain_validation_options" {
  description = "The domain validation options from the ACM certificate."
  type        = any
}
