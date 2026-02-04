# VLagent

Role to install and configure vlagent. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Description                                                                                                                | Default                                                                                               |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vlagent_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaLogs`                                                     |
| vlagent_version                     | vlagent version                                                                                                            | `v1.44.0`                                                                                             |
| vlagent_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                               |
| vlagent_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                  |
| vlagent_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                  |
| vlagent_download_url                | URL to download archive                                                                                                    | `{{ vlagent_repo_url }}/releases/download/{{ vlagent_version }}/vlutils-{{ vlagent_version }}.tar.gz` |
| vlagent_system_user                 | User to run vlagent                                                                                                        | `vic_vl_agent`                                                                                        |
| vlagent_system_group                | Group for user of vlagent                                                                                                  | `{{ vlagent_system_user }}`                                                                           |
| vlagent_remote_write_host           | Remote write host URL.                                                                                                     | `http://localhost:9428`                                                                               |
| vlagent_service_args                | Dict representing set of arguments for vlagent                                                                             | See [defaults](defaults/main.yml)                                                                     |
| vlagent_scrape_config               | Prometheus scrape configuration                                                                                            | See [defaults](defaults/main.yml)                                                                     |
| vlagent_aggregation_config          | Stream aggregation configuration                                                                                           | []                                                                                                    |
| vlagent_install_download_to_control | Whether use control or remote host to download installation archive                                                        | false                                                                                                 |
| vlagent_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                               |
| vl_proxy_http                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
| vl_proxy_https                      | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
