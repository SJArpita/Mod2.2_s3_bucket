locals {
 resource_prefix = "arp-tf"
}

resource "aws_instance" "public" {
 ami                         = "ami-053a45fff0a704a47" #Challenge, find the AMI ID of Amazon Linux 2 in us-east-1
 instance_type               = "t2.micro"
 subnet_id                   = data.aws_subnet.existing_ce9_pub_subnet.id
 associate_public_ip_address = true
 key_name                    = "arpita-keypair" #Change to your keyname, e.g. jazeel-key-pair
 vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 tags = {
   Name = "${ local.resource_prefix }-ec2-${ var.env }" # Ensure your
 }
}

output "ec2_public_ip" {
 value = aws_instance.public.public_ip
}

resource "aws_security_group" "allow_ssh" {
 name        = "${ local.resource_prefix }-security-group-ssh"
 description = "Allow SSH inbound"
 vpc_id      = data.aws_vpc.existing_ce9_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
 security_group_id = aws_security_group.allow_ssh.id
 cidr_ipv4         = "0.0.0.0/0" 
 from_port         = 22
 ip_protocol       = "tcp"
 to_port           = 22
}

output "ec2_public_dns" {
 value = aws_instance.public.public_dns
}