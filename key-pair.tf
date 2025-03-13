#------------------------------------------------------------------------------
# EC2 Key Pair
#------------------------------------------------------------------------------
resource "aws_key_pair" "this" {
  count = var.create_ec2_ssh_keypair ? 1 : 0

  key_name   = "bluegreen-keypair"
  public_key = tls_private_key.ssh_blue_green.public_key_openssh

  tags = merge(
    { Name = var.ec2_ssh_keypair_name },
    var.common_tags
  )
}

resource "tls_private_key" "ssh_blue_green" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# resource "local_file" "blue_green_private_key" {
#   content  = tls_private_key.ssh_blue_green.private_key_openssh
#   filename = "${path.module}/bluegreen-keypair.pem"

#   provisioner "local-exec" {
#     command = "chmod 400 ${path.module}/bluegreen-keypair.pem"
#   }
# }

