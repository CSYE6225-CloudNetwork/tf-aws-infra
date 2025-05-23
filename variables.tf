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

variable "hostDomain" {
  description = "host domain name"
  type        = string
  default     = "dev.aryaa-hanamar.me"
}

variable "cpu_low_thresh" {
  description = "cpu low threshld"
  type        = number
  default     = 3
}

variable "cpu_high_thresh" {
  description = "cpu high threshld"
  type        = number

  default = 5

}

variable "desired_capacity" {
  description = "desired capacity of instance"
  type        = number

  default = 3

}

variable "max_size" {
  description = "max_size of instance"
  type        = number

  default = 5

}

variable "min_size" {
  description = "min size of instance"
  type        = number

  default = 1
}

variable "secret_exists" {
  description = "Whether the secrets manager secret already exists"
  type        = bool
  default     = false
}

variable "use_existing_secret" {
  description = "Whether to use an existing secret in Secrets Manager"
  type        = bool
  default     = false # Set to true when you've created the secret manually

}
