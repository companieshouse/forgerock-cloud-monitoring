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
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/ForgeRock_Identity_Cloud-Monitoring_Demo.zip /var/tmp
  - wget https://dl.grafana.com/enterprise/release/grafana-enterprise-8.4.3-1.x86_64.rpm
  - yum install -y unzip grafana-enterprise-8.4.3-1.x86_64.rpm
  - unzip /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo.zip -d /var/tmp
  - cp -r  /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo/grafana/volume/* /var/lib/grafana/
  - chown -R grafana:grafana /var/lib/grafana/
  - systemctl enable grafana-server
  - systemctl start grafana-server
