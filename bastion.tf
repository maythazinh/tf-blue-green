data "aws_ami" "bastion" {
  count = var.create_bastion && var.create_vpc ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "bastion" {
  count = var.create_bastion && var.create_vpc ? 1 : 0

  ami                         = data.aws_ami.bastion[0].id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.bastion[0].id]
  key_name                    = "bluegreen-keypair" # Directly reference the aws_key_pair resource
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/templates/bastion_user_data.sh.tpl", {})

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = merge(
    { Name = "${var.friendly_name_prefix}-bastion" },
    var.common_tags
  )
}

resource "aws_security_group" "bastion" {
  count = var.create_bastion && var.create_vpc ? 1 : 0

  name   = "${var.friendly_name_prefix}-sg-bastion-allow"
  vpc_id = aws_vpc.main[0].id

  tags = merge(
    { Name = "${var.friendly_name_prefix}-sg-bastion-allow" },
    var.common_tags
  )
}

resource "aws_security_group_rule" "bastion_allow_ingress_ssh" {
  count = var.create_bastion && var.create_vpc ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.bastion_cidr_allow_ingress_ssh
  description = "Allow TCP/22 (SSH) from specified CIDR ranges inbound to bastion EC2 instance."

  security_group_id = aws_security_group.bastion[0].id
}

resource "aws_security_group_rule" "bastion_allow_egress_all" {
  count = var.create_bastion && var.create_vpc ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all traffic egress from bastion EC2 instance."

  security_group_id = aws_security_group.bastion[0].id
}