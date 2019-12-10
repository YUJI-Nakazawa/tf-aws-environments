resource "aws_iam_role" "admin_role" {
  name               = "AdminRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_common_policy_document.json
  max_session_duration = 43200 # 43,200[sec] = 12[hour]
}

data "aws_iam_policy_document" "assume_role_common_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    # AssumeRole元(Custodian)アカウントIDを指定
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${local.iam.root_aws_account_id}:root"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "admin_role_and_admin_policy_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
