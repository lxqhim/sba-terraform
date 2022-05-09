
resource "aws_launch_template" "lucas-frontend-template" {
  name_prefix            = "lucas-frontend"
  image_id               = "ami-02541b8af977f6cdd"
  instance_type          = "t3a.micro"
  vpc_security_group_ids = ["sg-0bf35b19260ac3de2"]
  user_data              = filebase64("frontend.sh")
}

resource "aws_autoscaling_group" "lucas-asg-80" {
  name                      = "lucas-asg-80"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  force_delete              = true
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = ["subnet-0e1b34255ca63ab75", "subnet-08da3471c29267d6d"]
  launch_template {
    id      = aws_launch_template.lucas-frontend-template.id
    version = "$Latest"
  }
  target_group_arns = ["arn:aws:elasticloadbalancing:us-west-1:175652158808:targetgroup/lucas-tg-80/6af9585853a654e4"]
}

resource "aws_autoscaling_policy" "lucas-frontend-policy" {
  name                   = "lucas-frontend-policy"
  autoscaling_group_name = aws_autoscaling_group.lucas-asg-80.name
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 20
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "lucas-frontend-policy"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = "test"
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}


