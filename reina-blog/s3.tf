resource "aws_s3_bucket" "mailbox" {
  bucket = "reina-blog-mailbox"
}

resource "aws_s3_bucket_policy" "mailbox" {
  bucket = aws_s3_bucket.mailbox.id
  policy = data.aws_iam_policy_document.mailbox.json
}

data "aws_iam_policy_document" "mailbox" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.mailbox.arn}/*"]
  }
}
