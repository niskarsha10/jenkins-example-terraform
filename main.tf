module "vpc-west" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = "aditya-vpc"

  cidr = "10.0.0.0/16"

  azs            = ["us-east-2a", "us-east-2c"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}
