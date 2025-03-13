# blue_green.tf

# Data source for the latest Amazon Linux 2 AMI (for Blue and Green instances)
data "aws_ami" "amazon_linux" {
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
}

# Security Group for Blue and Green Instances
resource "aws_security_group" "instance_sg" {
  name   = "${var.friendly_name_prefix}-sg-blue-green"
  vpc_id = aws_vpc.main[0].id

  # Allow HTTP from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion[0].id]
  }

  # Allow all egress (e.g., to download packages via NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.friendly_name_prefix}-sg-blue-green" },
    var.common_tags
  )
}

# Blue Instances (in private subnets)
resource "aws_instance" "blue" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private[count.index].id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = false
  key_name                    = "bluegreen-keypair"
  user_data                   = templatefile("${path.module}/templates/blue_user_data.sh.tpl", {})

  tags = merge(
    { Name = "${var.friendly_name_prefix}-blue-instance-${count.index + 1}" },
    var.common_tags
  )
}

# Green Instances (in private subnets)
resource "aws_instance" "green" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private[count.index].id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = false
  key_name                    = "bluegreen-keypair"
  user_data                   = templatefile("${path.module}/templates/green_user_data.sh.tpl", {})


  tags = merge(
    { Name = "${var.friendly_name_prefix}-green-instance-${count.index + 1}" },
    var.common_tags
  )
}