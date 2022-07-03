resource "aws_lb" "this" {
  name               = "basic-load-balancer"
  load_balancer_type = "network"
  subnets            = aws_subnet.public_a.id

  enable_cross_zone_load_balancing = true
}


resource "aws_lb_listener" "this" {
  for_each = var.ports

  load_balancer_arn = aws_lb.this.arn

  protocol = "TCP"
  port     = each.value

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

}

resource "aws_lb_target_group" "this" {
  for_each = var.ports

  port     = each.value
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  //stickiness = []

  depends_on = [
    aws_lb.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "target" {
  for_each = var.ports

  autoscaling_group_name = var.autoscaling_group_name
  alb_target_group_arn   = aws_lb_target_group.this[each.value].arn
}