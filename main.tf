
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
data "aws_availability_zonesrf4rf4rf4rf4" "available" {
  state = "available"
}
