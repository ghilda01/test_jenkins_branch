
################################################################################
# EC2 + Wireguard Module
################################################################################


################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "INFRA-${upper(var.aws_env)}"
  cidr = "10.193.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.193.1.0/24", "10.193.2.0/24", "10.193.3.0/24"]
  public_subnets  = ["10.193.4.0/24", "10.193.5.0/24", "10.193.6.0/24"]
  intra_subnets   = ["10.193.7.0/24", "10.193.8.0/24", "10.193.9.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  private_subnet_assign_ipv6_address_on_creation     = false
  public_subnet_assign_ipv6_address_on_creation      = false
  outpost_subnet_assign_ipv6_address_on_creation     = false
  database_subnet_assign_ipv6_address_on_creation    = false
  redshift_subnet_assign_ipv6_address_on_creation    = false
  elasticache_subnet_assign_ipv6_address_on_creation = false
  intra_subnet_assign_ipv6_address_on_creation       = false

  tags = { Purpose = "Test", Terraform = "True" }
}
module "wireguard" {
  source                  = "./modules/wireguard"
  wireguard_name          = "${module.vpc.name}_wireguard"
  wireguard_instance_type = var.wireguard_instance_type
  wireguard_vpc_id        = module.vpc.vpc_id
  wireguard_subnets_id    = module.vpc.public_subnets
  wireguard_aws_env       = var.aws_env
  wireguard_aws_region    = var.aws_region
  vpn_server_cidr = var.vpn_server_cidr
  wg_peers = var.wg_peers
  wg_server_port = var.wg_server_port
  wg_server_private_key = var.wg_server_private_key
  wg_server_public_key = var.wg_server_public_key

}