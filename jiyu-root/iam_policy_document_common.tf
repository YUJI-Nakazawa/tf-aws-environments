resource "aws_iam_policy" "common_policy" {
  name   = "CommonPolicy"
  policy = data.aws_iam_policy_document.common_policy_document.json
}

data "aws_iam_policy_document" "common_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:DecodeAuthorizationMessage",
      "sts:GetCallerIdentity",
      "sts:GetSessionToken",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:Get*",
      "iam:List*",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:ChangePassword",
      "iam:*LoginProfile",
      "iam:*AccessKey*",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]
  }
}
