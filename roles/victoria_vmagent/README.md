# VMagent

Role to install and configure vmagent. Installs by using binare from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Default                                                                                               | Description                                                         |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| vmagent_repo_url                    | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                  | Repository to use for download.                                     |
| vmagent_version                     | `v1.37.1`                                                                                             | vmagent version                                                     |
| vmagent_download_url                | `{{ vmagent_repo_url }}/releases/download/{{ vmagent_version }}/vmutils-{{ vmagent_version }}.tar.gz` | URL to download archive                                             |
| vmagent_system_user                 | `vic_vm_agent`                                                                                        | User to run vmagent                                                 |
| vmagent_system_group                | `{{ vmagent_system_user }}`                                                                           | Group for user of vmagent                                           |
| vmagent_config_dir                  | `/opt/vic-vmagent`                                                                                    | Path where configuration will be stored.                            |
| vmagent_sd_config_dir               | `{{ vmagent_config_dir }}/file_sd_configs`                                                            | Path to directory to configure file_sd.                             |
| vmagent_remote_write_host           | `http://localhost:8428`                                                                               | Remote write host URL.                                              |
| vmagent_service_args                | See [defaults](defaults/main.yml)                                                                     | Dict representing set of arguments for vmagent                      |
| vmagent_scrape_config               | See [defaults](defaults/main.yml)                                                                     | Prometheus scrape configuration                                     |
| vmagent_install_download_to_control | true                                                                                                  | Whether use control or remote host to download installation archive |
| vm_proxy_http                       | `""`                                                                                                  | Sets environment for downloading archive                            |
| vm_proxy_https                      | `""`                                                                                                  | Sets environment for downloading archive                            |
