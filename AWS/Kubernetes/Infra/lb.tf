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

  port     = "6443"
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

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
    aws_instance.control_plane,
    aws_instance.workers
  ]
}

resource "aws_lb_target_group_attachment" "this" {
  count            = var.master_count
  target_group_arn = aws_lb_target_group.this.arn
  target_id = aws_instance.control_plane[count.index].id
  port             = 6443

  depends_on = [
    aws_instance.control_plane,
    aws_instance.workers,
    aws_lb_target_group.this
  ]
}
