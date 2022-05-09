data "aws_vpc" "main" {
  id = "vpc-0b06ff4e4170b72f7"
}
data "aws_subnet_ids" "test" {
  vpc_id = data.aws_vpc.main.id
}


data "aws_subnet" "test" {
  for_each = data.aws_subnet_ids.test.ids
  id       = each.value
}
resource "aws_lb" "lucas-nlb" {
  name               = "lucas-nlb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "network"
  subnets            = ["subnet-03ad4fdfd1c73bf81", "subnet-0d34baca1bfb68606"]

}
resource "aws_lb_listener" "lucas-listener-80" {
  load_balancer_arn = aws_lb.lucas-nlb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lucas-tg-80.arn
  }
}
resource "aws_lb_target_group" "lucas-tg-80" {
  name     = "lucas-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_lb_listener" "lucas-listener-8080" {
  load_balancer_arn = aws_lb.lucas-nlb.arn
  port              = "8080"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lucas-tg-8080.arn
  }
}
resource "aws_lb_target_group" "lucas-tg-8080" {
  name     = "lucas-tg-8080"
  port     = 8080
  protocol = "TCP"
  vpc_id   = data.aws_vpc.main.id
}
