# Grant access to EC2 for fetching NGINX Plus certificate and key files from AWS Secrets Manager

resource "aws_iam_role" "nplus_sm_role" {
  name               = "${local.instance_prefix}-nplus-sm"
  assume_role_policy = file("files/policies/assume-role-policy.json")
}

resource "aws_iam_policy" "nplus_sm_ro_policy" {
  name        = "${local.instance_prefix}-nplus-sm-ro-policy"
  description = "Allow read only access to secrets in Secrets Manager"
  policy = templatefile("files/policies/nplus-secretsmanager-ro-policy.tpl", {
    nginx_plus_repo_cert = aws_secretsmanager_secret.nplus_cert.id
    nginx_plus_repo_key  = aws_secretsmanager_secret.nplus_key.id
  })
}

resource "aws_iam_policy_attachment" "nplus_sm_ro_policy_attachment" {
  name       = "${local.instance_prefix}-nplus-sm-ro-policy-attachment"
  roles      = ["${aws_iam_role.nplus_sm_role.name}"]
  policy_arn = aws_iam_policy.nplus_sm_ro_policy.arn
}

resource "aws_iam_instance_profile" "nplus_sm_profile" {
  name = "${local.instance_prefix}-nplus-sm-profile"
  role = aws_iam_role.nplus_sm_role.name
}
