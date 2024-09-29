provider "aws" {
    region = "ap-southeast-1"
    profile = "interview"
}

module "vpc" {
  source = "./vpc"
  environment = "global"

  vpc = {
    default_az = "ap-southeast-1"
    azs =  ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    cidr = "172.28.0.0/16"
    private_cidrs = [ "172.28.128.0/20", "172.28.144.0/20", "172.28.160.0/20" ]
    public_cidrs = [ "172.28.0.0/20", "172.28.16.0/20", "172.28.32.0/20" ]
    }
}

module "alb" {
  source = "./alb"
  environment = "global"
  asg = {
    public_subnet_ids = module.vpc.vpc_subnet_public_ids
    private_subnet_ids = module.vpc.vpc_subnet_private_ids
    private_subnet_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    sg_ids = [module.vpc.vpc_sg_id]
    ami_id = "ami-01811d4912b4ccb26"
  }
  alb = {
    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.vpc_subnet_public_ids
  }
}