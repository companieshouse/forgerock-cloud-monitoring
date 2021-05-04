resource "aws_lb" "prometheus" {
  name               = "${var.service_name}-prometheus"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.prometheus_lb.id]
}

resource "aws_lb_target_group" "prometheus" {
  name        = "${var.service_name}-prometheus"
  port        = 9090
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "prometheus" {
  target_group_arn = aws_lb_target_group.prometheus.arn
  target_id        = aws_instance.prometheus.private_ip
  port             = 9090
}

# TODO: Update to HTTPS
resource "aws_lb_listener" "prometheus" {
  load_balancer_arn = aws_lb.prometheus.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus.arn
  }
}

resource "aws_security_group" "prometheus_lb" {
  description = "Restricts access to the prometheus load balancer"
  name        = "${var.service_name}-prometheus-lb"
  vpc_id      = var.vpc_id

  ingress {
    description = "prometheus"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(var.vpn_cidrs, ["${var.grafana_ip}/32"])
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
