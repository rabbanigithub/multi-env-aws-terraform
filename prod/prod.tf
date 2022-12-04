module "vpc" {
  source     = "../modules/vpc"
  ENV        = "prod"
  AWS_REGION = var.AWS_REGION
}

module "instances" {
  source         = "../modules/instances"
  ENV            = "prod"
  INSTANCE_TYPE  = "t2.micro"
  VPC_ID         = module.vpc.vpc_id
  PUBLIC_SUBNETS = module.vpc.public_subnets
}
