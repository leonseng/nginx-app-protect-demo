#!/bin/bash
sudo amazon-linux-extras enable epel selinux-ng
sudo yum clean metadata
sudo yum install -y ca-certificates epel-release wget git
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.repo

# load Nginx Plus certificates
sudo mkdir -p /etc/ssl/nginx
sudo sh -c '\
  REPO_CRT_REGION=$(echo "${nplus_repo_crt}" | cut -d ":" -f 4); \
  aws --region $REPO_CRT_REGION secretsmanager get-secret-value --secret-id ${nplus_repo_crt} --query SecretString --output text > /etc/ssl/nginx/nginx-repo.crt; \
  REPO_KEY_REGION=$(echo "${nplus_repo_key}" | cut -d ":" -f 4); \
  aws --region $REPO_KEY_REGION secretsmanager get-secret-value --secret-id ${nplus_repo_key} --query SecretString --output text > /etc/ssl/nginx/nginx-repo.key; \
'

sudo yum install -y app-protect
sudo nginx -v

# load nginx.conf from remote source
sudo git clone ${nginx_conf_repo_url} .nginx-conf-repo
sudo cp .nginx-conf-repo/${nginx_conf_rel_path} /etc/nginx/nginx.conf

sudo systemctl start nginx
