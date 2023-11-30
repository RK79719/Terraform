## Internet gateway creation ##

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-module.id

  tags = {
    Name      = "vpc-module-gw"
    Terraform = "true"
  }
}

## Internet gateway attachment to VPC ##

resource "aws_internet_gateway_attachment" "gw_attach" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.vpc-module.id
}