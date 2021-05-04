locals {
  ami_root_block_device = tolist(data.aws_ami.prometheus.block_device_mappings)[index(data.aws_ami.prometheus.block_device_mappings.*.device_name, data.aws_ami.prometheus.root_device_name)]
}

data "aws_ami" "prometheus" {
  owners      = ["self"]
  most_recent = true
  name_regex  = "^prometheus-ami-\\d.\\d.\\d$"

  filter {
    name   = "name"
    values = ["prometheus-ami-*"]
  }
}

resource "aws_security_group" "instance" {
  description = "Restricts access to prometheus ${var.service_name} instance"
  name        = "${var.service_name}-prometheus-instance"
  vpc_id      = var.vpc_id

  ingress {
    description     = "prometheus"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.prometheus_lb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prometheus" {
  ami                    = data.aws_ami.prometheus.id
  iam_instance_profile   = aws_iam_instance_profile.prometheus.name
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, 0)
  user_data_base64       = data.template_cloudinit_config.prometheus.rendered
  vpc_security_group_ids = [aws_security_group.instance.id]

  root_block_device {
    volume_size = local.ami_root_block_device.ebs.volume_size
  }

  tags = {
    Name = "${var.service_name}-prometheus"
  }
}
