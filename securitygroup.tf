# Application Security Group
resource "aws_security_group" "app_sg" {
  name        = "application-security-group"
  description = "Allow SSH, HTTP, HTTPS, and app port access"
  vpc_id      = aws_vpc.main.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow application-specific port (e.g., 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "database-security-group"
  description = "Security group for RDS instance, allowing access only from the application security group"
  vpc_id      = aws_vpc.main.id

  # No direct inbound access from the internet (No 0.0.0.0/0 ingress rules)

  # Allow outbound traffic (needed for DB updates, backups, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-security-group"
  }
}

# Explicitly allow traffic from Application Security Group to Database Security Group
resource "aws_security_group_rule" "db_ingress" {
  type                     = "ingress"
  from_port                = 3306 # Change to 5432 for PostgreSQL
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

# Allow MySQL access from your local IP
# resource "aws_security_group_rule" "db_ingress_local" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   security_group_id = aws_security_group.db_sg.id
#   cidr_blocks       = ["155.33.132.7/32"]  # Replace with your actual IP
# }