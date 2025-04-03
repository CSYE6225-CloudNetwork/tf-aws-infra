# # Auto Scaling Group Definition
# resource "aws_autoscaling_group" "asg" {
#   desired_capacity = 1
#   max_size         = 5
#   min_size         = 3
#   launch_template {
#     id      = aws_launch_template.csye6225_asg.id
#     version = "$Latest"
#   }
#
#   vpc_zone_identifier = [aws_subnet.public[0].id] # Adjust with your subnet IDs
#
#   health_check_type         = "EC2"
#   health_check_grace_period = 300
#   default_cooldown          = 60
#   force_delete              = true
#
#   tag {
#     key                 = "Name"
#     value               = "csye6225-asg-instance"
#     propagate_at_launch = true
#   }
# }
#
# # EC2 Auto Scaling Policy - Scale Up
# resource "aws_autoscaling_policy" "scale_up" {
#   name                   = "scale_up_policy"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
#   policy_type            = "TargetTrackingScaling"
#
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value              = 70.0
#     estimated_instance_warmup = 300
#   }
# }
#
# # EC2 Auto Scaling Policy - Scale Down
# resource "aws_autoscaling_policy" "scale_down" {
#   name                   = "scale_down_policy"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
#   policy_type            = "SimpleScaling"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
# }