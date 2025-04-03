
data "aws_route53_zone" "selected_zone" {
  name = var.hostDomain
}


# Define an A record to point to the EC2 instance's public IP


resource "aws_route53_record" "ec2_a_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = data.aws_route53_zone.selected_zone.name
  type    = "A"

  alias {
    name                   = aws_lb.webapp_lb.dns_name
    zone_id                = aws_lb.webapp_lb.zone_id
    evaluate_target_health = true
  }
}
