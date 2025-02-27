resource "aws_instance" "app_server" {
  ami                    = var.aws_ami_id # Replace with your custom AMI ID
  instance_type          = var.aws_instance_type
  key_name               = var.aws_key_name # Replace with your key pair
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "HealthCheckAPI-Server"
  }
}

