data "aws_acm_certificate" "certificate" {
  count  = var.create_certificate ? 0 : 1
  domain = var.certificate_domain
}

data "aws_route53_zone" "domain" {
  count = var.create_route53_record ? 1 : 0
  name  = var.route53_zone
}

resource "aws_acm_certificate" "certificate" {
  count             = var.create_certificate ? 1 : 0
  domain_name       = "${var.service_name}-grafana.${var.domain_name}"
  validation_method = "DNS"

  tags = var.tags
}

resource "aws_route53_record" "certificate_validation" {
  count   = var.create_certificate ? 1 : 0
  name    = element(aws_acm_certificate.certificate.0.domain_validation_options.*.resource_record_name, 0)
  type    = element(aws_acm_certificate.certificate.0.domain_validation_options.*.resource_record_type, 0)
  zone_id = data.aws_route53_zone.domain.0.id
  records = [element(aws_acm_certificate.certificate.0.domain_validation_options.*.resource_record_value, 0)]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  count                   = var.create_certificate ? 1 : 0
  certificate_arn         = aws_acm_certificate.certificate.0.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.0.fqdn]
}

resource "aws_route53_record" "lb" {
  count   = var.create_route53_record ? 1 : 0
  name    = "${var.service_name}-grafana.${var.domain_name}"
  zone_id = data.aws_route53_zone.domain.0.id
  type    = "A"
  alias {
    name                   = aws_lb.grafana.dns_name
    zone_id                = aws_lb.grafana.zone_id
    evaluate_target_health = false
  }
}

resource "aws_lb" "grafana" {
  name               = "${var.service_name}-grafana"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.grafana_lb.id]

  tags = var.tags
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

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "grafana" {
  target_group_arn = aws_lb_target_group.grafana.arn
  target_id        = aws_instance.grafana.private_ip
  port             = 3000
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.create_certificate ? aws_acm_certificate_validation.certificate.0.certificate_arn : data.aws_acm_certificate.certificate.0.arn

  default_action {
    target_group_arn = aws_lb_target_group.grafana.arn
    type             = "forward"
  }
}

resource "aws_security_group" "grafana_lb" {
  description = "Restricts access to the grafana load balancer"
  name        = "${var.service_name}-grafana-lb"
  vpc_id      = var.vpc_id

  ingress {
    description = "Grafana HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidrs
  }

  ingress {
    description = "Grafana HTTPS"
    from_port   = 443
    to_port     = 443
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

  tags = var.tags
}
