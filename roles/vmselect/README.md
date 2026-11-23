# vmselect

Role to install and configure vmselect. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                            | Description                                                                                                                | Default                                                                                                  |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| vmselect_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                     |
| vmselect_version                     | vmselect version                                                                                                           | `v1.157.0`                                                                                               |
| vmselect_enterprise                  | Whether to use enterprise version of binaries. Releases that no longer verify license keys run with `-eula`, see [Enterprise installation](../../enterprise.md). | `false`                                                                                                  |
| vmselect_license_key                 | License key for enterprise. Ignored by releases that run with `-eula`, see [Enterprise installation](../../enterprise.md). | `""`                                                                                                     |
| vmselect_license_key_file            | License key file for enterprise. Ignored by releases that run with `-eula`, see [Enterprise installation](../../enterprise.md). | `""`                                                                                                     |
| vmselect_accept_eula                        | Accept the [Enterprise Software Agreement](https://victoriametrics.com/legal/esa/). Must be `true` for enterprise releases that run with `-eula`. Falls back to `vm_enterprise_accept_eula`. | `false` |
| vmselect_service_name                | Name of the installed system service                                                                                       | `vmselect`                                                                                               |
| vmselect_download_url                | URL to download archive                                                                                                    | `{{ vmselect_repo_url }}/releases/download/{{ vmselect_version }}/victoria-metrics{{ vmselect_platform }}-{{ go_arch }}-{{ vmselect_version }}-cluster.tar.gz` |
| vmselect_system_user                 | User to run vmselect                                                                                                       | `victoriametrics`                                                                                        |
| vmselect_system_group                | Group for user of vmselect                                                                                                 | `{{ vmselect_system_user }}`                                                                             |
| vmselect_service_state               | Default state of systemd service                                                                                           | `started`                                                                                                |
| vmselect_service_enabled             | Whether to enable systemd service                                                                                          | `true`                                                                                                   |    
| vmselect_config_dir                  | Location for config files                                                                                                  | `/opt/victoriametrics-vmselect`                                                                          |
| vmselect_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                         |
| vmselect_config                      | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                  |
| vmselect_cache_dir                   | Cache directory to use for vmselect's cache                                                                                | `"/var/lib/vmselect"`                                                                                    |
| vmselect_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                     |
| vmselect_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                     |
| vmselect_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                   |
| vmselect_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                  |
| vmselect_ansible_no_log              | Hide output (including `--diff`) of tasks that handle the license key. Falls back to `vm_ansible_no_log`, which sets it for all roles at once | `true`  |
| vm_proxy_http                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |
| vm_proxy_https                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |

## Configuration via environment variables

This role configures vmselect using environment variables with `-envflag.enable`. Each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

For example, to set the `-search.maxUniqueTimeseries` flag, use `search_maxUniqueTimeseries` as the key in `vmselect_config`:

```yaml
vmselect_config:
  storageNode: "vmstorage1,vmstorage2,vmstorage3"
  search_maxUniqueTimeseries: 900000  # corresponds to -search.maxUniqueTimeseries flag
```
