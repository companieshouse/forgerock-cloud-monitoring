runcmd:
  - pip3 install awscli
  - yum install -y unzip
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/ForgeRock_Identity_Cloud-Monitoring_Demo.zip /var/tmp
  - aws s3 cp s3://development-eu-west-2.resources.ch.gov.uk/packages/forgerock/prometheus.tmpl.yml /var/tmp
  - unzip /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo.zip -d /var/tmp
  - cp -r /var/tmp/ForgeRock_Identity_Cloud-Monitoring_Demo/prometheus/volume/* /var/opt/prometheus/
  - chown -R prometheus:prometheus /var/opt/prometheus/
  - cat /var/tmp/prometheus.tmpl.yml | sed "s/##API_KEY_ID##/${API_KEY_ID}/g" | sed "s/##API_KEY_SECRET##/${API_KEY_SECRET}/g" | sed "s/##TENANT_DOMAIN##/${TENANT_DOMAIN}/g" > /etc/prometheus/prometheus.yml
  - systemctl enable prometheus
  - systemctl start prometheus