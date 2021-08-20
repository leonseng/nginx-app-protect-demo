variable "project_name" {
  type        = string
  description = "Project name to prefix AWS objects"
}

variable "project_region" {
  type        = string
  description = "AWS region to create resource in"
}

variable "base_ami" {
  type        = string
  description = "AWS machine image ID"
}


#
# NGINX Plus Repository SSL files
#
variable "secrets_manager_nginx_plus_repo_certificate_arn" {
  type        = string
  description = "ARN of NGINX Plus repository certificate secret on AWS Secrets Manager"
}

variable "secrets_manager_nginx_plus_repo_key_arn" {
  type        = string
  description = "ARN of NGINX Plus repository key secret on AWS Secrets Manager"
}

#
# nginx.conf Git repository
#
variable "nginx_conf_repo_url" {
  type        = string
  description = "Git repository URL containing nginx.conf"
}

variable "nginx_conf_relative_path" {
  type        = string
  description = "Relative path of nginx.conf within cloned Git repository"
}
