public_subnet_settings = [
  {
    name              = "PublicSubnet1"
    cidr_block        = "10.0.101.0/24"
    availability_zone = "ap-south-1a"
  },
  {
    name              = "PublicSubnet2"
    cidr_block        = "10.0.102.0/24"
    availability_zone = "ap-south-1b"
  },
]
private_subnet_settings = [
  {
    name              = "PublicSubnet1"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
  },
  {
    name              = "PublicSubnet2"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
  },
]