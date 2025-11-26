
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "*.testpagespage.space"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = var.validation_record_fqdns
}
