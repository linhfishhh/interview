
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}



variable "environment" {

}


variable "vpc" {
  type = object({
    default_az    = string
    cidr          = string
    azs           = list(string)
    public_cidrs  = list(string)
    private_cidrs = list(string)
    cluster_name  = string
  })
}


resource "aws_vpc" "vpc_global" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc_global"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet_global_public" {
  count = length(var.vpc.public_cidrs)

  vpc_id                  = aws_vpc.vpc_global.id
  cidr_block              = element(var.vpc.public_cidrs, count.index)
  availability_zone       = element(var.vpc.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "subnet_${var.environment}_public_${format("%03d", count.index + 1)}"
    Environment                                     = var.environment
  }
}

resource "aws_subnet" "subnet_global_private" {
  count = length(var.vpc.private_cidrs)

  vpc_id            = aws_vpc.vpc_global.id
  cidr_block        = element(var.vpc.private_cidrs, count.index)
  availability_zone = element(var.vpc.azs, count.index)

  tags = {
    Name                                            = "subnet_${var.environment}_private_${format("%03d", count.index + 1)}"
    Environment                                     = var.environment
  }
}

resource "aws_internet_gateway" "ig_global" {
  vpc_id = aws_vpc.vpc_global.id

  tags = {
    Name        = "ig_${var.environment}"
    Environment = var.environment
  }
}

resource "aws_eip" "eip_global" {
}

resource "aws_nat_gateway" "nat_global" {
  allocation_id = aws_eip.eip_global.id
  subnet_id     = aws_subnet.subnet_global_public[0].id
  depends_on = [
    aws_internet_gateway.ig_global,
    aws_eip.eip_global,
  ]

  tags = {
    Name        = "nat_${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table" "rt_global_public" {
  vpc_id = aws_vpc.vpc_global.id

  tags = {
    Name        = "rt_${var.environment}_public"
    Environment = var.environment
  }
}

resource "aws_route" "rt_route_global_public" {
  route_table_id         = aws_route_table.rt_global_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_global.id
}

resource "aws_route_table_association" "rt_association_global_public" {
  count = length(var.vpc.azs)

  subnet_id      = element(aws_subnet.subnet_global_public.*.id, count.index)
  route_table_id = aws_route_table.rt_global_public.id
}

resource "aws_route_table" "rt_global_private" {
  vpc_id = aws_vpc.vpc_global.id

  tags = {
    Name        = "rt_${var.environment}_private"
    Environment = var.environment
  }
}

resource "aws_route" "rt_route_global_private" {
  route_table_id         = aws_route_table.rt_global_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_global.id
}

resource "aws_route_table_association" "rt_association_private" {
  count = length(var.vpc.azs)

  subnet_id      = element(aws_subnet.subnet_global_private.*.id, count.index)
  route_table_id = aws_route_table.rt_global_private.id
}

#
# Output
#

output "vpc_id" {
  value = aws_vpc.vpc_global.id
}

output "vpc_rt_id" {
  value = aws_route_table.rt_global_public.id
}

output "vpc_nat_public_ip" {
  value = aws_nat_gateway.nat_global.public_ip
}

output "vpc_subnet_public_ids" {
  value = aws_subnet.subnet_global_public.*.id
}

output "vpc_subnet_private_ids" {
  value = aws_subnet.subnet_global_private.*.id
}