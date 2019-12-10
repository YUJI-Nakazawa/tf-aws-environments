resource "aws_cloudfront_distribution" "distribution" {
  aliases = [local.route53.www_domain_name]
  enabled = true

  origin {
    domain_name = local.route53.wp_domain_name
    origin_id   = local.cloudfront.wp_origin

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront.wp_origin

    forwarded_values {
      query_string = true
      headers      = [
        "CloudFront-Forwarded-Proto",
        "Host",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-SmartTV-Viewer",
        "CloudFront-Is-Tablet-Viewer"
      ]

      cookies {
        forward           = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 31536000
  }

  ordered_cache_behavior {
    path_pattern     = "wp-admin/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront.wp_origin

    forwarded_values {
      query_string = true
      headers      = [
        "CloudFront-Forwarded-Proto",
        "Host",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-SmartTV-Viewer",
        "CloudFront-Is-Tablet-Viewer"
      ]

      cookies {
        forward           = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "*.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront.wp_origin

    forwarded_values {
      query_string = true
      headers      = [
        "CloudFront-Forwarded-Proto",
        "Host",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-SmartTV-Viewer",
        "CloudFront-Is-Tablet-Viewer"
      ]

      cookies {
        forward           = "all"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  depends_on = ["aws_acm_certificate_validation.certificate_validation"]
}
