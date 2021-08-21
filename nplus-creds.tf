resource "aws_secretsmanager_secret" "nplus_cert" {
  name = "${var.project_name}-nplus-cert"
}

resource "aws_secretsmanager_secret_version" "nplus_cert_value" {
  secret_id     = aws_secretsmanager_secret.nplus_cert.id
  secret_string = file(var.nginx_plus_repo_cert_path)
}

resource "aws_secretsmanager_secret" "nplus_key" {
  name = "${var.project_name}-nplus-key"
}

resource "aws_secretsmanager_secret_version" "nplus_key_value" {
  secret_id     = aws_secretsmanager_secret.nplus_key.id
  secret_string = file(var.nginx_plus_repo_key_path)
}
