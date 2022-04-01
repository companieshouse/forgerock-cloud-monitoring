runcmd:
  %{~ for block_device in lvm_block_devices ~}
  %{ if block_device.filesystem_resize_tool != "" }
  - 'echo "Resizing volume (GiB): ${block_device.lvm_logical_volume_device_node} -> [${block_device.aws_volume_size_gb}]"'
  - pvresize ${block_device.lvm_physical_volume_device_node}
  - lvresize -l +100%FREE ${block_device.lvm_logical_volume_device_node}
  - ${block_device.filesystem_resize_tool} ${block_device.lvm_logical_volume_device_node}
  %{ endif }
  %{~ endfor ~}
  - xfs_growfs ${root_volume_device_node}
  - wget https://dl.grafana.com/enterprise/release/grafana-enterprise-8.4.3-1.x86_64.rpm
  - yum install -y unzip grafana-enterprise-8.4.3-1.x86_64.rpm
  - systemctl enable grafana-server
  - systemctl start grafana-server
