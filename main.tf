provider "aws" {
  region = var.project_region
}

resource "random_string" "random" {
  length  = 16
  special = false
}

locals {
  instance_prefix = "${var.project_name}-${random_string.random.result}"
}

resource "aws_key_pair" "nplus_ssh_key" {
  key_name_prefix = "${local.instance_prefix}-"
  public_key      = var.ssh_public_key
  count           = var.ssh_public_key == null ? 0 : 1
}

resource "aws_security_group" "allow_access" {
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress = [
    {
      description      = "icmp"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "NGINX HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "NGINX HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "${local.instance_prefix}-sg"
  }
}

resource "aws_instance" "nplus" {
  ami                  = var.base_ami
  instance_type        = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.nplus_sm_profile.name
  key_name             = var.ssh_public_key == null ? null : aws_key_pair.nplus_ssh_key[0].id
  subnet_id            = aws_subnet.my_subnet.id
  vpc_security_group_ids = [
    "${aws_security_group.allow_access.id}"
  ]

  user_data = templatefile("files/run.sh.tpl", {
    region              = var.project_region
    nplus_repo_crt      = aws_secretsmanager_secret.nplus_cert.id
    nplus_repo_key      = aws_secretsmanager_secret.nplus_key.id
    nginx_conf_repo_url = var.nginx_conf_repo_url
    nginx_conf_rel_path = var.nginx_conf_relative_path
  })

  tags = {
    Name = "${local.instance_prefix}-instance"
  }

  depends_on = [
    aws_secretsmanager_secret_version.nplus_cert_value,
    aws_secretsmanager_secret_version.nplus_key_value
  ]
}

resource "aws_eip" "nplus_eip" {
  vpc = true

  instance   = aws_instance.nplus.id
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${local.instance_prefix}-eip"
  }
}
