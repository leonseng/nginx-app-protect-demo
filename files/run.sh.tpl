#!/bin/bash
sudo amazon-linux-extras enable epel selinux-ng
sudo yum clean metadata
sudo yum install -y ca-certificates epel-release wget git
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.repo
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-dos-7.repo

# load Nginx Plus certificates
sudo mkdir -p /etc/ssl/nginx
sudo sh -c '\
  aws --region ${region} secretsmanager get-secret-value --secret-id ${nplus_repo_crt} --query SecretString --output text > /etc/ssl/nginx/nginx-repo.crt; \
  aws --region ${region} secretsmanager get-secret-value --secret-id ${nplus_repo_key} --query SecretString --output text > /etc/ssl/nginx/nginx-repo.key; \
'

sudo yum install -y app-protect app-protect-dos
sudo nginx -v
sudo admd -v

# load nginx.conf from remote source
sudo git clone ${nginx_conf_repo_url} /tmp/.nginx-conf-repo
sudo cp -r /tmp/.nginx-conf-repo/${nginx_conf_rel_path}/* /etc/nginx/

# create directory to store NGINX App Protect logs
sudo mkdir -p /var/log/nginx/app_protect
sudo chown nginx:nginx /var/log/nginx/app_protect

sudo systemctl start nginx
