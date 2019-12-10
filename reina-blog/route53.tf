resource "aws_route53_zone" "route53_zone" {
  name          = local.route53.root_domain_name
  force_destroy = true
}

resource "aws_route53_record" "wp_a_record" {
  name    = local.route53.wp_domain_name
  type    = "A"
  ttl     = "300"
  zone_id = aws_route53_zone.route53_zone.id
  records = [aws_lightsail_static_ip.lightsail_static_ip.ip_address]
}

resource "aws_route53_record" "www_a_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = local.route53.www_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

