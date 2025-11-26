
output "acm_certificate_arn" {
  value = aws_acm_certificate_validation.alb_cert_validation.certificate_arn
}

output "domain_validation_options" {
  value = aws_acm_certificate.alb_cert.domain_validation_options
}
