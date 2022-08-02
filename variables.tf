variable "aws_env" {
  description = "AWS environment name"
  default     = "dev-dgh"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "wireguard_instance_type" {
  default = "t3a.nano"
}

variable "vpn_server_cidr" {
  default = "172.16.16.0/20"
}

variable "wg_server_port" {
  type = number
  default = 51820
}

variable "wg_server_private_key" {
  default = "2NeAmS4qLt97KDDkzJzLtaT2pOuygcgUtteCmB39q2M="
}

variable "wg_server_public_key" {
  default = "EpM0RIL+4iaHvsotrYR2gaIA/OEmZ0ZmQwfn0dHx6Qo="
}

variable "wg_peers" {
  type = list
  default = [{
    name = "dummy"
    public_key = "bwqhoU48AwbOh/58xz7k4wbYnIOKEWzinFrmDarvqGk="
    allowed_ips = "172.16.16.2"
  }]
}