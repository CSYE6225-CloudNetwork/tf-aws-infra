# Reference existing KMS keys
data "aws_kms_key" "ec2_key" {
  key_id = "arn:aws:kms:us-west-2:940482446477:key/ff41cd7c-fa84-4534-9567-3566c6f64bc4" # or use the ARN/ID directly
}

data "aws_kms_key" "rds_key" {
  key_id = "arn:aws:kms:us-west-2:940482446477:key/bc1e1fcc-78af-405c-bd0c-5e057981c99a" # or use the ARN/ID directly
}

data "aws_kms_key" "s3_key" {
  key_id = "arn:aws:kms:us-west-2:940482446477:key/e5b1a7b6-f5e6-4eeb-95f6-53da78be0f1b" # or use the ARN/ID directly
}

data "aws_kms_key" "secrets_key" {
  key_id = "arn:aws:kms:us-west-2:940482446477:key/a2cf6d5d-1e75-4c59-821f-c762dc8ab791" # or use the ARN/ID directly
}