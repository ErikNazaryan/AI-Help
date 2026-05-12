provider "aws" {
  region = "eu-north-1"
}

# 1. VPC Մոդուլ (Ցանցը)
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24"]
  availability_zones   = ["eu-north-1a", "eu-north-1b"]
  environment          = "genesis"
}

# 2. ALB Մոդուլ (Load Balancer)
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# 3. ASG Մոդուլ (Սերվերներ)
module "asg" {
  source            = "./modules/asg"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
}