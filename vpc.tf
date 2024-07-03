module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "nyc-tf-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.0.0/17"]
  public_subnets  = ["10.0.128.0/17"]

#   enable_nat_gateway     = true
#   single_nat_gateway     = true
#   one_nat_gateway_per_az = false

  tags = {
    env       = "tf"
  }
}
