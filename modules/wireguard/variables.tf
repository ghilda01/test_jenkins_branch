variable "wireguard_aws_env" {
}
variable "wireguard_aws_region" {
}
variable "wireguard_name" {
}
variable "wireguard_instance_type" {
}
variable "wireguard_vpc_id" {
}
variable "wireguard_subnets_id" {
}
variable "vpn_server_cidr" {
}

variable "wg_server_port" {
  type = number
}

variable "wg_server_private_key" {
}

variable "wg_server_public_key" {
}

variable "wg_peers" {
  type = list
}