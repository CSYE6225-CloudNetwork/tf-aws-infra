resource "aws_launch_template" "csye6225_asg" {

  name = "csye6225_asg_launch_template"

  image_id      = var.aws_ami_id
  instance_type = var.aws_instance_type
  key_name      = var.aws_key_name

  block_device_mappings {
    device_name = "/dev/xvda" # Root volume device name for Amazon Linux 2
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = data.aws_kms_key.ec2_key.arn
    }
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash


  # Add debugging
  exec > >(tee /var/log/user-data.log) 2>&1
  echo "Starting user data script execution"

  # Set region variable
  AWS_REGION="${var.aws_region}"
  echo "AWS Region: $AWS_REGION"

  # Install MySQL client
  echo "Installing MySQL client..."
  sudo apt-get update
  sudo apt-get install -y mysql-client-core-8.0 jq unzip curl

  # Install AWS CLI v2 - DO NOT use apt-get for awscli
  echo "Installing AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
  sudo ./aws/install

  # Make sure to use the full path to AWS CLI
  echo "Verifying AWS CLI installation..."
  /usr/local/bin/aws --version

  # Fetch the RDS endpoint using Terraform variables
  RDS_ENDPOINT="${aws_db_instance.csye6225.endpoint}"
  S3Bucket="${aws_s3_bucket.attachments.id}"
  echo "RDS Endpoint: $RDS_ENDPOINT"
  echo "S3 Bucket: $S3Bucket"

  # Get database credentials from Secrets Manager using the full path to aws
  echo "Retrieving database credentials from Secrets Manager"
  SECRET=$(/usr/local/bin/aws secretsmanager get-secret-value --secret-id db-password-secret --region $AWS_REGION --query SecretString --output text)

  # Extract username and password
  DB_USERNAME=$(echo $SECRET | jq -r '.username')
  DB_PASSWORD=$(echo $SECRET | jq -r '.password')

  # Create directory with sudo
  echo "Creating environment directory"
  sudo mkdir -p /etc/environment.d

  # Write to the file using sudo tee
  echo "Writing configuration file"
  sudo tee /etc/environment.d/csye6225.conf > /dev/null <<EOL
  database=jdbc:mysql://$RDS_ENDPOINT/csye6225
  username=$DB_USERNAME
  password=$DB_PASSWORD

  S3_BUCKET_NAME=$S3Bucket
  aws_region=$AWS_REGION
  LOG_FILE_PATH=${var.LOG_FILE_PATH}
  EOL


  # Verify the file was created
  echo "Verifying file creation:"
  ls -la /etc/environment.d/

  echo "Starting application services"
  sudo systemctl start csye6225 || echo "Failed to start csye6225 service"
  sudo systemctl restart amazon-cloudwatch-agent || echo "Failed to restart cloudwatch agent"

  echo "User data script completed"

  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}
