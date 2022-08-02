data "template_file" "wireguard_userdata_peers" {
  template = file("./modules/wireguard/resources/wireguard-user-data-peers.tpl")
  count = length(var.wg_peers)
  vars = {
    peer_name = var.wg_peers[count.index].name
    peer_public_key = var.wg_peers[count.index].public_key
    peer_allowed_ips = var.wg_peers[count.index].allowed_ips
  }
}

data "template_file" "wireguard_userdata" {
  template = file("./modules/wireguard/resources/wireguard-user-data.tpl")
  vars = {
    client_network_cidr = var.vpn_server_cidr
    wg_server_private_key = var.wg_server_private_key
    wg_server_public_key = var.wg_server_public_key
    wg_server_port = var.wg_server_port
    wg_peers = join("\n", data.template_file.wireguard_userdata_peers.*.rendered)
  }
}

# Lookup the AMI instance that corresponds to a Ubuntu server
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

# Create a security group that allows access to the EC2 instance
resource "aws_security_group" "wireguard" {
  name = "${var.wireguard_name}_sg"
  description = "Communication to and from VPC endpoint"
  vpc_id = var.wireguard_vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision the actual EC2 instance based on the AMI selected above

resource "aws_instance" "wireguard" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.wireguard_instance_type
  subnet_id = var.wireguard_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.wireguard.id]
  user_data = data.template_file.wireguard_userdata.rendered
  tags = {
    Name = var.wireguard_name
  }
}