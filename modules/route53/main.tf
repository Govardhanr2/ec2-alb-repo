
resource "aws_route53_record" "alb_cert_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  name    = each.value.name
  type    = each.value.type
  zone_id = var.zone_id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_route53_record" "alb_docker" {
  zone_id = var.zone_id
  name    = "ec2-alb-docker.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_instance" {
  zone_id = var.zone_id
  name    = "ec2-alb-instance.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_docker1" {
  zone_id = var.zone_id
  name    = "ec2-docker1.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_docker2" {
  zone_id = var.zone_id
  name    = "ec2-docker2.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_instance1" {
  zone_id = var.zone_id
  name    = "ec2-instance1.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_instance2" {
  zone_id = var.zone_id
  name    = "ec2-instance2.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
