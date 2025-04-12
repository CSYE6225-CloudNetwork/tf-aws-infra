data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  description = "Policy for EC2 to access S3, RDS, and KMS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Existing S3 permissions
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.attachments.id}",
          "arn:aws:s3:::${aws_s3_bucket.attachments.id}/*"
        ]
      },
      # Updated KMS permissions - ensure all required permissions are included
      {
        Effect = "Allow"
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:ReEncrypt*"
        ]
        Resource = [
          data.aws_kms_key.ec2_key.arn,
          data.aws_kms_key.rds_key.arn,
          data.aws_kms_key.s3_key.arn,
          data.aws_kms_key.secrets_key.arn
        ]
      },
      # EC2 permissions (unchanged)
      {
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume"
        ]
        Resource = [
          "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:volume/*"
        ]
      },
      # RDS permissions (unchanged)
      {
        Action = [
          "rds:DescribeDBInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Policy for Terraform to access KMS
resource "aws_iam_policy" "terraform_kms_access" {
  name        = "terraform_kms_access"
  description = "Allow Terraform to access KMS keys"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:ListKeys",
          "kms:EnableKey",
          "kms:EnableKeyRotation",
          "kms:CreateAlias",
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "secrets_access" {
  name = "secrets-access"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt",
        ]
        Effect = "Allow"
        Resource = [
          data.aws_kms_key.secrets_key.arn,
          "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:db-password-secret*"
        ]
      }
    ]
  })
}



resource "aws_kms_grant" "asg_grant" {
  name              = "asg-service-grant"
  key_id            = data.aws_kms_key.ec2_key.id  # Using your existing key reference
  grantee_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "DescribeKey",
    "CreateGrant"
  ]
}

resource "aws_iam_role_policy" "kms_unified_access" {
  name = "kms_unified_access"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey",
          "kms:ReEncrypt*"
        ]
        Resource = [
          data.aws_kms_key.ec2_key.arn,
          data.aws_kms_key.rds_key.arn,
          data.aws_kms_key.s3_key.arn,
          data.aws_kms_key.secrets_key.arn,
        ]
      }
    ]
  })
}