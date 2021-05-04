runcmd:
  - xfs_growfs ${root_volume_device_node}
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/ForgeRock_Identity_Cloud-Monitoring_Demo.zip /var/tmp
  - yum install -y unzip
  - unzip /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo.zip -d /var/tmp
  - cp -r  /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo/grafana/volume/* /var/lib/grafana/
  - chown -R grafana:grafana /var/lib/grafana/
  - systemctl enable grafana-server
  - systemctl start grafana-server