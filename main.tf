
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
# main.tf
# Get available AZs in the region
data "aws_availability_zones" "available" {
  states = "available"
}
