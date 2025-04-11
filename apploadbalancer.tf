resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id # Adjust with your subnet IDs

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "webapp_tg" {
  name     = "webapp-target-group"
  port     = 5000 # Change to the port your application listens on
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id # Replace with your VPC ID

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

# attach Ec2 instace to loadBalancer
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.webapp_tg.arn
}

