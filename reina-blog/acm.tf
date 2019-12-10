resource "aws_acm_certificate" "certificate" {
  provider          = "aws.acm_provider"
  domain_name       = "*.${local.route53.root_domain_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "domain_validataion_record" {
  zone_id  = aws_route53_zone.route53_zone.id
  name     = aws_acm_certificate.certificate.domain_validation_options.0.resource_record_name
  type     = aws_acm_certificate.certificate.domain_validation_options.0.resource_record_type
  ttl      = "60"
  records  = [aws_acm_certificate.certificate.domain_validation_options.0.resource_record_value]
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider = "aws.acm_provider"
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [aws_route53_record.domain_validataion_record.fqdn]
}
