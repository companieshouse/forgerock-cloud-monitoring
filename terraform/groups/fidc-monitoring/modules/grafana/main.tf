locals {
  ami_root_block_device = tolist(data.aws_ami.grafana.block_device_mappings)[index(data.aws_ami.grafana.block_device_mappings.*.device_name, data.aws_ami.grafana.root_device_name)]
}

data "aws_ami" "grafana" {
  owners      = ["self"]
  most_recent = true
  name_regex  = "^grafana-ami-\\d.\\d.\\d$"

  filter {
    name   = "name"
    values = ["grafana-ami-*"]
  }
}

resource "aws_security_group" "instance" {
  description = "Restricts access to grafana ${var.service_name} instance"
  name        = "${var.service_name}-grafana-instance"
  vpc_id      = var.vpc_id

  # ingress {
  #   description = "Grafana"
  #   from_port   = 3000
  #   to_port     = 3000
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.grafana_load_balancer.id]
  # }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "grafana" {
  ami = data.aws_ami.grafana.id
  # iam_instance_profile   = aws_iam_instance_profile.grafana.name
  instance_type = "t2.micro"
  # key_name               = var.ssh_keyname
  subnet_id = element(var.subnet_ids, 0)
  # user_data_base64       = data.template_cloudinit_config.grafana.*.rendered[count.index]
  vpc_security_group_ids = [aws_security_group.instance.id]

  root_block_device {
    volume_size = local.ami_root_block_device.ebs.volume_size
  }

  # dynamic "ebs_block_device" {
  #   for_each = local.ami_lvm_block_devices
  #   iterator = block_device
  #   content {
  #     device_name = block_device.value.device_name
  #     encrypted   = block_device.value.ebs.encrypted
  #     iops        = block_device.value.ebs.iops
  #     snapshot_id = block_device.value.ebs.snapshot_id
  #     volume_size = var.lvm_block_devices[index(var.lvm_block_devices.*.lvm_physical_volume_device_node, block_device.value.device_name)].aws_volume_size_gb
  #     volume_type = block_device.value.ebs.volume_type
  #   }
  # }

  tags = {
    Name = "${var.service_name}-grafana"
  }
}