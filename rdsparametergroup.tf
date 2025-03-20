resource "aws_db_parameter_group" "mysql_pg" {
  name   = "custom-db-params"
  family = "mysql8.0"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }
}

# resource "aws_ssm_parameter" "rds_endpoint" {
#   name  = "/csye6225/rds-endpoint"
#   type  = "String"
#   value = aws_db_instance.csye6225.endpoint
#
#
#   tags = {
#     Name = "csye6225-rds-endpoint"
#   }
# }
