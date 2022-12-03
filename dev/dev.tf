module "main-vpc" {
  source     = "../modules/vpc"
  ENV        = "dev"
  AWS_REGION = var.AWS_REGION
}

module "instances" {
  source         = "../modules/instances"
  ENV            = "dev"
  INSTANCE_TYPE  = "t2.micro"
  VPC_ID         = module.main-vpc.vpc_id
  PUBLIC_SUBNETS = module.main-vpc.public_subnets
}
