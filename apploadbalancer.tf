# Add at the top of the file - data source for SSL certificate
data "aws_acm_certificate" "ssl_cert" {
  domain   = "demo.aryaa-hanamar.me"
  statuses = ["ISSUED"]
}

resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "webapp_tg" {
  name     = "webapp-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/healthz"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.webapp_tg.arn
    type             = "forward"
  }
}

# Add this new HTTPS listener for SSL
resource "aws_lb_listener" "webapp_listener_https" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.ssl_cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.webapp_tg.arn
    type             = "forward"
  }
}

# attach Ec2 instance to loadBalancer
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.webapp_tg.arn
}