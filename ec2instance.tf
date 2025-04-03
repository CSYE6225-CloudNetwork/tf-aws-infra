# resource "aws_instance" "app_server" {
#   ami                    = var.aws_ami_id
#   instance_type          = var.aws_instance_type
#   key_name               = var.aws_key_name
#   subnet_id              = aws_subnet.public[0].id
#   vpc_security_group_ids = [aws_security_group.app_sg.id]
#   iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#
#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }
#
#   user_data = <<-EOF
#   #!/bin/bash
#   set -e
#   AWS_REGION="${var.aws_region}"
#
#   # Install MySQL client (needed for testing or troubleshooting, if applicable)
#   sudo apt-get update
#   sudo apt-get install -y mysql-client-core-8.0
#
#   # Fetch the RDS endpoint dynamically
#   RDS_ENDPOINT="${aws_db_instance.csye6225.endpoint}"
#   S3Bucket="${aws_s3_bucket.attachments.id}"
#   echo "RDS Endpoint: $RDS_ENDPOINT"
#
#   # Save database configuration to environment file
#   mkdir -p /etc/environment.d
#   cat > /etc/environment.d/csye6225.conf <<EOL
#   database=jdbc:mysql://$RDS_ENDPOINT/csye6225
#   username=${var.username}
#   password=${var.password}
#   S3_BUCKET_NAME=$S3Bucket
#   aws_region=$AWS_REGION
#   LOG_FILE_PATH=${var.LOG_FILE_PATH}
#   EOL
#
#   echo "Database configuration saved!"
#
#   # Start the application (adjust with your application startup command)
#   sudo systemctl start csye6225
#   sudo systemctl restart amazon-cloudwatch-agent
# EOF
#
#
#   tags = {
#     Name = "HealthCheckAPI-Server"
#   }
# }
