# outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "rds_endpoint" {
  value = aws_db_instance.csye6225.endpoint
}

output "s3_bucket_id" {
  value = aws_s3_bucket.attachments.bucket
}
# output "ec2_public_ip" {
#   value = aws_instance.app_server.public_ip
# }

output "load_balancer_dns" {
  value       = aws_lb.webapp_lb.dns_name
  description = "Public DNS of the Application Load Balancer"
}

output "asg_instances" {
  value = aws_autoscaling_group.asg.id
}
