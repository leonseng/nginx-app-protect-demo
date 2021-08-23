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

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to be loaded onto the NGINX Plus EC2 instance"
  default     = null
}

#
# NGINX Plus Repository SSL files
#
variable "nginx_plus_repo_cert_path" {
  type        = string
  description = "File path of NGINX Plus repository certificate nginx-repo.crt"
}

variable "nginx_plus_repo_key_path" {
  type        = string
  description = "File path of NGINX Plus repository key nginx-repo.key"
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
  description = "Relative path of directory containing NGINX configuration files and App Protect policies within cloned Git repository"
}
