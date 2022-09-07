# VMauth

Role to install and configure `vmauth`. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Description                                                         | Default                                                                                               |
|-------------------------------------|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vic_vm_auth_repo_url                | Repository to use for download.                                     | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                  |
| vic_vm_auth_version                 | vmagent version                                                     | `v1.81.1`                                                                                             |
| vic_vm_auth_download_url            | URL to download archive                                             | `{{ vic_vm_auth_repo_url }}/releases/download/{{ vic_vm_auth_version }}/vmutils{{ vic_vm_auth_platform }}-{{ go_arch }}-{{ vic_vm_auth_version }}.tar.gz` |
| vic_vm_auth_system_user             | User to run vmagent                                                 | `vic_vm_vmauth`                                                                                        |
| vic_vm_auth_system_group            | Group for user of vmagent                                           | `{{ vic_vm_auth_system_user }}`                                                                           |
| vic_vm_auth_config_dir              | Path where configuration will be stored.                            | `/opt/vic-vmauth`                                                                                    |
| vic_vm_auth_service_args            | Dict representing set of arguments for vmagent                      | See [defaults](defaults/main.yml)                                                                     |
| vic_vm_auth_configs                 | List of users auth rules                                            | See [defaults](defaults/main.yml)                                                                     |
| vm_proxy_http                       | Sets environment for downloading archive                            | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                            | `""`                                                                                                  |
