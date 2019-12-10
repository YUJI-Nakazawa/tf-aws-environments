resource "aws_ses_domain_identity" "ses_domain_identity" {
  provider = "aws.ses_provider"
  domain = local.route53.root_domain_name
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  provider = "aws.ses_provider"
  domain   = aws_ses_domain_identity.ses_domain_identity.domain
}

resource "aws_route53_record" "ses_record" {
  zone_id  = aws_route53_zone.route53_zone.id
  name     = "_amazonses.${aws_ses_domain_identity.ses_domain_identity.domain}"
  type     = "TXT"
  ttl      = "600"
  records  = [
    aws_ses_domain_identity.ses_domain_identity.verification_token]
}

resource "aws_route53_record" "ses_dkim_record" {
  count    = 3
  zone_id  = aws_route53_zone.route53_zone.id
  name     = "${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.ses_domain_identity.domain}"
  type     = "CNAME"
  ttl      = "600"
  records  = ["${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_ses_domain_identity_verification" "ses_domain_identify_verification" {
  provider = "aws.ses_provider"
  domain   = aws_ses_domain_identity.ses_domain_identity.domain
  depends_on = [
    "aws_route53_record.ses_record",
    "aws_route53_record.ses_dkim_record",
  ]
}

# メール送受信に使用するメールアドレスの検証
resource "aws_ses_email_identity" "ses_email_identity" {
  provider = "aws.ses_provider"
  email = local.ses.email_address
}

resource "aws_ses_receipt_rule_set" "ses_receipt_rule_set" {
  provider = "aws.ses_provider"
  rule_set_name = "s3"
}

resource "aws_ses_receipt_rule" "ses_receipt_rule" {
  provider = "aws.ses_provider"
  name          = "s3"
  rule_set_name = aws_ses_receipt_rule_set.ses_receipt_rule_set.rule_set_name
  recipients    = [local.ses.email_address]
  enabled       = true
  scan_enabled  = true
  s3_action {
    bucket_name = aws_s3_bucket.mailbox.id
    object_key_prefix = "mailbox/${local.ses.email_address}"
    position = 1
  }
}

# ルールセットをアクティブにする
resource "aws_ses_active_receipt_rule_set" "ses_active_receipt_rule_set" {
  provider = "aws.ses_provider"
  rule_set_name = aws_ses_receipt_rule_set.ses_receipt_rule_set.rule_set_name
}

resource "aws_route53_record" "ses_mx_record" {
  zone_id  = aws_route53_zone.route53_zone.id
  name     = local.route53.root_domain_name
  type     = "MX"
  ttl      = "600"
  records  = ["10 inbound-smtp.us-west-2.amazonaws.com"]
}
