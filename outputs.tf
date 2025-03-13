#------------------------------------------------------------------------------
# Networking
#------------------------------------------------------------------------------
output "vpc_id" {
  value       = try(aws_vpc.main[0].id, null)
  description = "VPC ID."
}

output "private_subnet_ids" {
  value       = try(aws_subnet.private.*.id, null)
  description = "Subnet IDs of private subnets."
}

output "public_subnet_ids" {
  value       = try(aws_subnet.public.*.id, null)
  description = "Subnet IDs of public subnets."
}

output "bastion_public_dns" {
  value       = try(aws_instance.bastion[0].public_dns, null)
  description = "Public DNS name of bastion EC2 instance."
}

output "bastion_public_ip" {
  value       = try(aws_instance.bastion[0].public_ip, null)
  description = "Public IP of bastion EC2 instance."
}

output "bastion_private_ip" {
  value       = try(aws_instance.bastion[0].private_ip, null)
  description = "Private IP of bastion EC2 instance."
}

output "public_key" {
  value = tls_private_key.ssh_blue_green.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.ssh_blue_green.private_key_openssh
  sensitive = true
}