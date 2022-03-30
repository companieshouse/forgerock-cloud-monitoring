resource "aws_security_group" "grafana_instances" {
  description = "Restricts access to grafana ${var.service} instances"
  name = "${var.service}-${var.environment}-grafana-instances"
  vpc_id = var.vpc_id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidrs
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.grafana_load_balancer.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-grafana"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}

resource "aws_security_group" "grafana_load_balancer" {
  description = "Restricts access to the grafana load balancer"
  name = "${var.service}-${var.environment}-grafana-load-balancer"
  vpc_id = var.vpc_id

  ingress {
    description = "Grafana"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.grafana_cidrs
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-grafana"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}
