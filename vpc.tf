
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  // try to get as many azs as needed to stripe subnets across them.
  az_subsets = slice(data.aws_availability_zones.available.names, 0, length(var.subnets))
}

output "cidr" {
  value = [for sk, sv in var.subnets : sv.cidr]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.network.cidr

  azs             = local.az_subsets
  public_subnets  = [for sk, sv in var.subnets : sv.cidr if sv.private == false]
  private_subnets = [for sk, sv in var.subnets : sv.cidr if sv.private == true]

  enable_nat_gateway = var.network.enable_nat_gateway
  enable_vpn_gateway = var.network.enable_vpn_gateway

  enable_dns_support                                = true
  enable_dns_hostnames                              = true
  map_public_ip_on_launch                           = true
  public_subnet_private_dns_hostname_type_on_launch = "resource-name"

  tags = merge({
    stack = var.name
    role  = "vpc"
    unit  = "primary"
    },
    var.common_tags,
    var.network.tags,
  )
}
