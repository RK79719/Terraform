resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "nginx-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_settings)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_settings[count.index].cidr_block
  availability_zone = var.private_subnet_settings[count.index].availability_zone

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_settings)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_settings[count.index].cidr_block
  availability_zone = var.public_subnet_settings[count.index].availability_zone

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-nginx"
  }
}

resource "aws_route_table" "public_subnet_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the Internet Gateway
    gateway_id = aws_internet_gateway.example_igw.id
  }

  depends_on = [aws_subnet.public_subnet]
}

resource "aws_route_table_association" "public_subnet_association1" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_route.id
}






