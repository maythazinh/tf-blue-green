#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
  default     = "blue-green"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

#------------------------------------------------------------------------------
# Networking
#------------------------------------------------------------------------------
variable "create_vpc" {
  type        = bool
  description = "Boolean to create a VPC."
  default     = true
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC."
  default     = "vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR ranges to create in VPC."
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR ranges to create in VPC."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "create_bastion" {
  type        = bool
  description = "Boolean to create a bastion EC2 instance. Only valid when `create_vpc` is `true`."
  default     = true
}

variable "bastion_ec2_keypair_name" {
  type        = string
  description = "Existing SSH key pair to use for bastion EC2 instance."
  default     = "bluegreen-keypair"
}

variable "bastion_cidr_allow_ingress_ssh" {
  type        = list(string)
  description = "List of source CIDR ranges to allow inbound to bastion on port 22 (SSH)."
  default     = ["0.0.0.0/0"]
}

#------------------------------------------------------------------------------
# EC2 SSH Key Pairs
#------------------------------------------------------------------------------
variable "create_ec2_ssh_keypair" {
  type        = bool
  description = "Boolean to create EC2 SSH key pair. This is separate from the `bastion_keypair` input variable."
  default     = true
}

variable "ec2_ssh_keypair_name" {
  type        = string
  description = "Name of EC2 SSH key pair."
  default     = "blue green key"
}

variable "ec2_ssh_public_key" {
  type        = string
  description = "Public key material for EC2 SSH Key Pair."
  default     = null
}