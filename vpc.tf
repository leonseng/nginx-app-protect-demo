resource "aws_vpc" "default" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-gw"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "172.16.10.0/24"

  tags = {
    Name = "${var.project_name}-sn"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.default.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
