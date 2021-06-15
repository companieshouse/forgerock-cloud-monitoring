locals {
  ami_root_block_device = tolist(data.aws_ami.grafana.block_device_mappings)[index(data.aws_ami.grafana.block_device_mappings.*.device_name, data.aws_ami.grafana.root_device_name)]
}

data "aws_ami" "grafana" {
  owners      = [var.ami_account_id]
  most_recent = true
  name_regex  = "^grafana-ami-\\d.\\d.\\d$"

  filter {
    name   = "name"
    values = ["grafana-ami-*"]
  }
}

resource "aws_security_group" "instance" {
  description = "Restricts access to grafana ${var.service_name} instance"
  name_prefix = "${var.service_name}-grafana-instance-"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Grafana"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.grafana_lb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "grafana" {
  ami                    = data.aws_ami.grafana.id
  iam_instance_profile   = aws_iam_instance_profile.grafana.name
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, 0)
  user_data_base64       = data.template_cloudinit_config.grafana.rendered
  vpc_security_group_ids = [aws_security_group.instance.id]

  root_block_device {
    volume_size = local.ami_root_block_device.ebs.volume_size
  }

  tags = merge(var.tags, {
    Name = "${var.service_name}-grafana"
  })
}
