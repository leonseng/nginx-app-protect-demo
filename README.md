# NGINX Plus App Protect AWS Demo

This repository contains Terraform files to deploy an NGINX Plus server running on AWS EC2.

The deployment requires the following files to be available:

1. NGINX Plus subscription files `nginx-repo.key` and `nginx-repo.crt`
1. `nginx.conf` and App Protect policies in a directory hosted on a public Git repository. See [example](files/nginx/).

## Instructions

Create a variable file `input.tfvars` at the project root based on [input.tfvars.example](./input.tfvars.example). The descriptions of the variables are available in [variables.tf](./variables.tf)

Initialize and perform a dry run with
```
terraform init
terraform plan -var-file=input.tfvars
```

Next, create the resources with
```
terraform apply -var-file=input.tfvars
```

Once the resources have been created, test the NGINX Plus server
```
curl $(terraform output -raw nplus_public_ip)
```

If `ssh_public_key` is provided as an input variable, you can SSH to the server via
```
ssh -o StrictHostKeyChecking=no ec2-user@$(terraform output -raw nplus_public_ip)
```
