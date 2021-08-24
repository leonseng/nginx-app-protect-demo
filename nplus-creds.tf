
resource "aws_secretsmanager_secret" "nplus_cert" {
  name = "${local.instance_prefix}-nplus-cert"
}

resource "aws_secretsmanager_secret_version" "nplus_cert_value" {
  secret_id     = aws_secretsmanager_secret.nplus_cert.id
  secret_string = file(var.nginx_plus_repo_cert_path)
}

resource "aws_secretsmanager_secret" "nplus_key" {
  name = "${local.instance_prefix}-nplus-key"
}

resource "aws_secretsmanager_secret_version" "nplus_key_value" {
  secret_id     = aws_secretsmanager_secret.nplus_key.id
  secret_string = file(var.nginx_plus_repo_key_path)
}
