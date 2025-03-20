resource "aws_db_instance" "csye6225" {
  identifier           = var.rds_identifier
  allocated_storage    = 10
  db_name              = "csye6225"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.username
  password             = var.password
  parameter_group_name = aws_db_parameter_group.mysql_pg.name

  db_subnet_group_name   = aws_db_subnet_group.csye6225_db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id] # Attach DB security group

  publicly_accessible = false # Ensures DB is not exposed to the internet - mark it as false when deploying on remote
  multi_az            = false # Keeps cost low (no multi-AZ)
  storage_encrypted   = true  # Encrypts data at rest
  skip_final_snapshot = true  # Avoids snapshot creation on deletion (only for dev/test)

  tags = {
    Name = "csye6225-db"
  }
}

resource "aws_db_subnet_group" "csye6225_db_subnet" {
  name        = "csye6225-db-subnet-group"
  description = "Private subnet group for CSYE6225 RDS"
  #  description = "PUBLIC subnet group for CSYE6225 RDS"

  # Use all private subnets dynamically
  subnet_ids = aws_subnet.private[*].id
  #  subnet_ids = aws_subnet.public[*].id
  tags = {
    Name = "csye6225-db-subnet-group"
  }
}
