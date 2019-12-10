resource "aws_iam_group" "admin_group" {
  name = "AdminGroup"
}

resource "aws_iam_group_policy_attachment" "admin_group_and_common_policy_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.common_policy.arn
}

resource "aws_iam_group_policy_attachment" "admin_group_and_admin_policy_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
