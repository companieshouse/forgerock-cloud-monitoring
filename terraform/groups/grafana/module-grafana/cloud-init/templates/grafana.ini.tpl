write_files:
  - path: /etc/grafana/grafana.ini
    owner: ${grafana_service_user}:${grafana_service_group}
    permissions: 0644
    content: |
      [auth.ldap]
      enabled = true
      config_file = /etc/grafana/ldap.toml
      allow_sign_up = true

      [security]
      admin_password = "${grafana_admin_password}"
