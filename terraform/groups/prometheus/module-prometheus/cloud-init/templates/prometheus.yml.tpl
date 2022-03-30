write_files:

  - path: /etc/prometheus/prometheus.yml
    owner: prometheus:prometheus
    permissions: 0644
    content: |
      global:
        scrape_interval:     60s
        evaluation_interval: 30s
        scrape_timeout: 30s

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
          - targets: ['localhost:9090','localhost:9100']

        - job_name: AM
          metrics_path: /monitoring/prometheus/am
          scheme: https
          basic_auth:
          username: "${api_key_id}"
          password: "${api_key_secret}"
          static_configs:
          - targets:
          - ${fidc_domain}

        - job_name: IDM
        metrics_path: /monitoring/prometheus/idm
        scheme: https
        basic_auth:
        username: "${api_key_id}"
        password: "${api_key_secret}"
        static_configs:
        - targets:
          - ${fidc_domain}
