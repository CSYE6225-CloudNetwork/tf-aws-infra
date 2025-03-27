
data "aws_route53_zone" "selected_zone" {
  name = var.hostDomain
}

# Define an A record to point to the EC2 instance's public IP
resource "aws_route53_record" "ec2_a_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.hostDomain
  type    = "A"
  ttl     = 300
  records = [aws_instance.app_server.public_ip]

  depends_on = [aws_instance.app_server]
}
