resource "aws_lb" "grafana" {
  name               = "${var.service_name}-grafana"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.grafana_lb.id]
}

resource "aws_lb_target_group" "grafana" {
  name        = "${var.service_name}-grafana"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/login"
    interval            = 60
  }
}

resource "aws_lb_target_group_attachment" "grafana" {
  target_group_arn = aws_lb_target_group.grafana.arn
  target_id        = aws_instance.grafana.private_ip
  port             = 3000
}

# TODO: Update to HTTPS
resource "aws_lb_listener" "grafana" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }
}

resource "aws_security_group" "grafana_lb" {
  description = "Restricts access to the grafana load balancer"
  name        = "${var.service_name}-grafana-lb"
  vpc_id      = var.vpc_id

  ingress {
    description = "Grafana"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidrs
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
