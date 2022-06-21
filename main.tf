module "aadi_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = "aadi-vpc"

  cidr = "10.0.0.0/16"

  azs            = ["us-east-2a", "us-east-2c"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}
module "aadi-sg" {
  source = "terraform-aws-modules/vpc/aws"

  name        = "aadi-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
}

