module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  private_subnet_tags = {
    Name = "terraform private"
  }
  public_subnet_tags = {
    Name = "terraform public"
  }

  tags = local.tags

  vpc_tags = {
    Name = "terraform vpc"
  }
}