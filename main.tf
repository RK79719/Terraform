
## VPC Creation ##

module "vpc" {
  source = "./modules/vpc"
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
}


## Security group creation ##

module "web_server_sg" {
  source     = "./modules/sg"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]

}

## Instance creation with nginx installed ##

module "ec2-module" {
  source           = "./modules/ec2"
  sg_id            = module.web_server_sg.sg_id
  public_subnet_id = module.vpc.public_subnet_id
  depends_on       = [module.vpc, module.web_server_sg]
}


## Template , ASG & LB ##

module "asg-module" {
  source         = "./modules/ASG-LB"
  sg_id          = module.web_server_sg.sg_id
  vpc_id         = module.vpc.vpc_id
  instance_id    = module.ec2-module.instance_id
  ami_id         = module.ec2-module.ami_id
  public_subnets = module.vpc.public_subnets
  depends_on     = [module.vpc, module.web_server_sg, module.ec2-module]
}

## S3 & DynamoDB table definition
/*
module "backend" {
  source = "./modules/backend"
}*/







