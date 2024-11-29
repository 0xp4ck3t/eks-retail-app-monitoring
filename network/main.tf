# --- network/main.tf ---


resource "random_integer" "random" {
  min = 1
  max = 100
}

#AZ
data "aws_availability_zones" "available" {
  state = "available"
}

#VPC
resource "aws_vpc" "k8_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "k8_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}



#Subnet
resource "aws_subnet" "k8_public" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.k8_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.k8_vpc.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "k8_public_${count.index + 1}"
  }
}

resource "aws_subnet" "k8_private" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.k8_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.k8_vpc.cidr_block, 8, count.index + 4)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "k8_private_${count.index + 1}"
  }
}

#IGW
resource "aws_internet_gateway" "k8_igw" {
  vpc_id = aws_vpc.k8_vpc.id
}


#EIP
resource "aws_eip" "nat" {
  domain = "vpc"
}

#NAT GW
resource "aws_nat_gateway" "k8_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.k8_public[0].id
}

#Route Table
resource "aws_route_table" "k8_public_rt" {
  vpc_id = aws_vpc.k8_vpc.id
  tags = {
    Name = "K8_public_RT"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.k8_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.k8_igw.id
}

resource "aws_route_table" "k8_private_rt" {
  vpc_id = aws_vpc.k8_vpc.id

  tags = {
    Name = "K8_private_RT"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.k8_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.k8_nat.id
}

resource "aws_route_table_association" "k8_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.k8_public[count.index].id
  route_table_id = aws_route_table.k8_public_rt.id
}

resource "aws_route_table_association" "k8_private_assoc" {
  count          = var.private_sn_count
  route_table_id = aws_route_table.k8_private_rt.id
  subnet_id      = aws_subnet.k8_private[count.index].id

}

#Security Group
resource "aws_security_group" "http_security_group" {
  for_each    = var.https_security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.k8_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  #   ingress {
  #     description = "SSH Access"
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "TCP"
  #     cidr_blocks = [var.access_ip]
  #   }
}

resource "aws_security_group" "ssh_security_group" {
  for_each    = var.ssh_security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.k8_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = [var.access_ip]
    }
  }
}

resource "aws_security_group" "k8_ALB" {
  for_each    = var.alb_security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.k8_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "k8_DB" {
#   name = "DB_SG"
#   description = "SG for DB"
#   vpc_id = aws_vpc.k8_vpc.id
#
#   ingress {
#     description = "DB Access"
#     from_port = 3306
#     to_port = 3306
#     cidr_blocks = [for subnet in aws_subnet.k8_private : subnet.cidr_block]
#   }
# }






