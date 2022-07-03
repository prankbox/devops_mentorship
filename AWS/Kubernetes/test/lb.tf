resource "aws_lb" "this" {
  name               = "basic-load-balancer"
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_a.id]

  enable_cross_zone_load_balancing = true
}


resource "aws_lb_listener" "this" {
  #for_each = var.ports

  load_balancer_arn = aws_lb.this.arn

  protocol = "TCP"
  port     = "6443"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

}

resource "aws_lb_target_group" "this" {
  #for_each = var.ports

  port     = "6443"
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

data "aws_instances" "nlb_insts" {
  instance_state_names = ["running"]

  depends_on = [
    module.ec2_instance
  ]
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = [for sc in range(var.inst_count) : data.aws_instances.nlb_insts.ids[sc]]
  port             = 6443

  depends_on = [
    module.ec2_instance,
    aws_lb_target_group.this
  ]
}





# resource "aws_autoscaling_attachment" "target" {
#   for_each = var.ports

#   autoscaling_group_name = "masters"
#   lb_target_group_arn   = aws_lb_target_group.this.arn
# }