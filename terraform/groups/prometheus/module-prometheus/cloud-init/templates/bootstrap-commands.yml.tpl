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
  - pip3 install awscli
  - yum install -y unzip
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/ForgeRock_Identity_Cloud-Monitoring_Demo.zip /var/tmp
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/prometheus.tmpl.yml /var/tmp
  - unzip /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo.zip -d /var/tmp
  - cp -r /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo/prometheus/volume/* /var/opt/prometheus/
  - chown -R prometheus:prometheus /var/opt/prometheus/
  - systemctl enable prometheus
  - systemctl start prometheus
