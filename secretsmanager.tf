
# resource "aws_secretsmanager_secret" "db_password" {
#   name                    = "db-password-secret"
#   kms_key_id              = aws_kms_key.secrets_key.arn
#   recovery_window_in_days = 0  # Set to 0 for testing, use 7-30 for production
# }
#
# resource "aws_secretsmanager_secret_version" "db_password" {
#   secret_id     = aws_secretsmanager_secret.db_password.id
#   secret_string = jsonencode({
#     username = var.username
#     password = var.password
#   })
# }


# resource "aws_secretsmanager_secret" "email_credentials" {
#   name                    = "email-service-credentials"
#   kms_key_id              = aws_kms_key.secrets_key.arn
#   recovery_window_in_days = 0  # Set to 0 for testing, use 7-30 for production
# }

# resource "aws_secretsmanager_secret_version" "email_credentials" {
#   secret_id     = aws_secretsmanager_secret.email_credentials.id
#   secret_string = jsonencode({
#     email    = "your-service-email@example.com"
#     password = var.email_service_password
#   })
# }