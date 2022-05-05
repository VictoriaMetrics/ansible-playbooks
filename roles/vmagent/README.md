# VMagent

Role to install and configure vmagent. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Description                                                         | Default                                                                                               |
|-------------------------------------|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vmagent_repo_url                    | Repository to use for download.                                     | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                  |
| vmagent_version                     | vmagent version                                                     | `v1.77.0`                                                                                             |
| vmagent_download_url                | URL to download archive                                             | `{{ vmagent_repo_url }}/releases/download/{{ vmagent_version }}/vmutils-{{ vmagent_version }}.tar.gz` |
| vmagent_system_user                 | User to run vmagent                                                 | `vic_vm_agent`                                                                                        |
| vmagent_system_group                | Group for user of vmagent                                           | `{{ vmagent_system_user }}`                                                                           |
| vmagent_config_dir                  | Path where configuration will be stored.                            | `/opt/vic-vmagent`                                                                                    |
| vmagent_sd_config_dir               | Path to directory to configure file_sd.                             | `{{ vmagent_config_dir }}/file_sd_configs`                                                            |
| vmagent_remote_write_host           | Remote write host URL.                                              | `http://localhost:8428`                                                                               |
| vmagent_service_args                | Dict representing set of arguments for vmagent                      | See [defaults](defaults/main.yml)                                                                     |
| vmagent_scrape_config               | Prometheus scrape configuration                                     | See [defaults](defaults/main.yml)                                                                     |
| vmagent_install_download_to_control | Whether use control or remote host to download installation archive | true                                                                                                  |
| vm_proxy_http                       | Sets environment for downloading archive                            | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                            | `""`                                                                                                  |
