resource "aws_iam_group_membership" "admin_group_membership" {
  name  = "AdminGroupMembership"
  group = aws_iam_group.admin_group.name

  users = [
    aws_iam_user.yuji_nakazawa.name
  ]
}
