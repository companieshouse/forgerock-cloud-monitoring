write_files:
  - path: /etc/grafana/ldap.toml
    owner: ${grafana_service_user}:${grafana_service_group}
    permissions: 0644
    content: |
      [[servers]]
      host = "${ldap_auth_host}"
      port = ${ldap_auth_port}
      use_ssl = ${ldap_auth_use_ssl}
      start_tls = ${ldap_auth_start_tls}
      ssl_skip_verify = ${ldap_auth_ssl_skip_verify}
      bind_dn = "${ldap_auth_bind_dn}"
      bind_password = "${ldap_auth_bind_password}"
      search_filter = "${ldap_auth_search_filter}"
      search_base_dns = ["${ldap_auth_search_base_dns}"]

      [servers.attributes]
      name = "givenName"
      surname = "sn"
      username = "cn"
      member_of = "memberOf"
      email = "email"

      [[servers.group_mappings]]
      group_dn = "${ldap_grafana_admin_group_dn}"
      org_role = "Admin"
      grafana_admin = true

      [[servers.group_mappings]]
      group_dn = "${ldap_grafana_admin_group_dn}"
      org_role = "Editor"

      [[servers.group_mappings]]
      group_dn = "${ldap_grafana_viewer_group_dn}"
      org_role = "Viewer"
