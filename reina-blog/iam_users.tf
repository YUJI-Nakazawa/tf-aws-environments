resource "aws_iam_user" "cloudfront_cache_controller" {
  name = "cloudfront-cache-controller"
  force_destroy = true
}

resource "aws_iam_user_policy" "cloudfront_cache_controller_policy" {
  name = "test"
  user = aws_iam_user.cloudfront_cache_controller.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudfront:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
