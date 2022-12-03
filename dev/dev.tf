module "vpc" {
  source     = "../modules/vpc"
  ENV        = "dev"
  AWS_REGION = var.AWS_REGION
}

module "instances" {
  source         = "../modules/instances"
  ENV            = "dev"
  INSTANCE_TYPE  = "t2.micro"
  VPC_ID         = module.vpc.vpc_id
  PUBLIC_SUBNETS = module.vpc.public_subnets
}
