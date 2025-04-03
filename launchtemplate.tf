resource "aws_launch_template" "csye6225_asg" {
  name_prefix   = "csye6225_asg"
  image_id      = var.aws_ami_id
  instance_type = var.aws_instance_type
  key_name      = var.aws_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  set -e
  AWS_REGION="${var.aws_region}"

  # Install MySQL client (needed for testing or troubleshooting, if applicable)
  sudo apt-get update
  sudo apt-get install -y mysql-client-core-8.0

  # Fetch the RDS endpoint dynamically
  RDS_ENDPOINT="${aws_db_instance.csye6225.endpoint}"
  S3Bucket="${aws_s3_bucket.attachments.id}"
  echo "RDS Endpoint: $RDS_ENDPOINT"

  # Save database configuration to environment file
  mkdir -p /etc/environment.d
  cat > /etc/environment.d/csye6225.conf <<EOL
  database=jdbc:mysql://$RDS_ENDPOINT/csye6225
  username=${var.username}
  password=${var.password}
  S3_BUCKET_NAME=$S3Bucket
  aws_region=$AWS_REGION
  LOG_FILE_PATH=${var.LOG_FILE_PATH}
  EOL

  echo "Database configuration saved!"

  # Start the application (adjust with your application startup command)
  sudo systemctl start csye6225
  sudo systemctl restart amazon-cloudwatch-agent
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}
