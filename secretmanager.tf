# Generate a random password for MySQL
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Reference the existing secret
data "aws_secretsmanager_secret" "existing_db_password" {
  name = "db-password-secret"
}

# Only manage the secret version (password update)
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.existing_db_password.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.db_password.result
  })
}