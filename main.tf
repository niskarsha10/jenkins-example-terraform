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

module "main_sg" {
  source = "./modules/terraform-aws-security-group"

  description = "Security group which is used as an argument in complete-sg"
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Service name"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
