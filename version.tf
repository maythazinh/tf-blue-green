terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.54.0"
    }
  }
}


# provider "aws" {
#   profile = "online-testing" # Replace with your AWS profile name
#   region  = "us-east-1"      # Replace with your desired region
# }
