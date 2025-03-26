# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "profile" {
  description = "profile tag (e.g. dev, demo)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "aws_ami_id" {
  description = "aws ami ID"
  type        = string
}

variable "aws_instance_type" {
  description = "aws ami instance"
  type        = string
}

variable "aws_key_name" {
  description = "aws ami key name"
  type        = string
}

variable "rds_identifier" {
  description = "RDS Instance Identifier"
  type        = string
}

# variable "aws_account_id" {
#   description = "AWS account Identifier - DEV/DEMO"
#   type        = string
# }

variable "password" {
  description = "RDS user password"
  type        = string
}

variable "username" {
  description = "RDS username"
  type        = string
}

variable "LOG_FILE_PATH" {
  description = "log file path"
  type        = string
  default     = "/opt/csye6225/application.log"
}
