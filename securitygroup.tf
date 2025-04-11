# Load Balancer Security Group (Handles incoming web traffic)
resource "aws_security_group" "lb_sg" {
  name        = "load-balancer-security-group"
  description = "Allow HTTP/HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "load-balancer-security-group"
  }
}

# Application Security Group (Restricts access from Load Balancer & SSH from a specific IP)
resource "aws_security_group" "app_sg" {
  name        = "application-security-group"
  description = "Allow SSH, HTTP, HTTPS, and app port access only from Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from a specific IP (replace "your_ip_address/32" with your actual IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your actual IP
  }

  # Allow HTTP from Load Balancer security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Only from Load Balancer
  }

  # Allow HTTPS from Load Balancer security group
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Only from Load Balancer
  }

  # Allow application-specific port (e.g., 5000) from Load Balancer security group
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Only from Load Balancer
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

# Database Security Group (Only allows traffic from the Application Security Group)
resource "aws_security_group" "db_sg" {
  name        = "database-security-group"
  description = "Security group for RDS instance, allowing access only from the application security group"
  vpc_id      = aws_vpc.main.id

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
  from_port                = 3306 # MySQL port (use 5432 for PostgreSQL)
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}
