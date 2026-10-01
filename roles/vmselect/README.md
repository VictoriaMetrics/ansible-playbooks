# vmselect

Role to install and configure vmselect. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                            | Description                                                                                                                | Default                                                                                                  |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| vmselect_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                     |
| vmselect_version                     | vmselect version                                                                                                           | `v1.148.0`                                                                                               |
| vmselect_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                                  |
| vmselect_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                     |
| vmselect_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                     |
| vmselect_service_name                | Name of the installed system service                                                                                       | `vmselect`                                                                                               |
| vmselect_download_url                | URL to download archive                                                                                                    | `{{ vmselect_repo_url }}/releases/download/{{ vmselect_version }}/victoria-metrics{{ vmselect_platform }}-{{ go_arch }}-{{ vmselect_version }}-cluster.tar.gz` |
| vmselect_system_user                 | User to run vmselect                                                                                                       | `victoriametrics`                                                                                        |
| vmselect_system_group                | Group for user of vmselect                                                                                                 | `{{ vmselect_system_user }}`                                                                             |
| vmselect_service_state               | Default state of systemd service                                                                                           | `started`                                                                                                |
| vmselect_service_enabled             | Whether to enable systemd service                                                                                          | `true`                                                                                                   |    
| vmselect_config_dir                  | Location for config files                                                                                                  | `/opt/victoriametrics-vmselect`                                                                          |
| vmselect_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                         |
| vmselect_service_envflag_data        | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                  |
| vmselect_cache_dir                   | Cache directory to use for vmselect's cache                                                                                | `"/var/lib/vmselect"`                                                                                    |
| vmselect_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                     |
| vmselect_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                     |
| vmselect_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                   |
| vmselect_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                  |
| vm_proxy_http                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |
| vm_proxy_https                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |

## Deprecated aliases

`vmselect_config` is deprecated in favor of `vmselect_service_envflag_data`, which matches the naming used by the other roles, and will be removed in a future release. The old name still works (it is used as a fallback when the new name is unset), and the role emits a deprecation warning when it detects it. It is accepted as input only: the role no longer defines `vmselect_config` as a default, so a playbook that reads it after the role (for example `{{ vmselect_config.storageNode }}`) must read `vmselect_service_envflag_data` instead. [playbooks/cluster.yml](../../playbooks/cluster.yml) sets `vmselect_service_envflag_data` as a play var, so `-e vmselect_config=...` no longer has any effect on that playbook - pass `-e vmselect_service_envflag_data=...` instead. Migrate to the new name:

| Deprecated      | Use instead                   |
|-----------------|-------------------------------|
| vmselect_config | vmselect_service_envflag_data |

## Configuration via environment variables

This role configures vmselect using environment variables with `-envflag.enable`. Each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

For example, to set the `-search.maxUniqueTimeseries` flag, use `search_maxUniqueTimeseries` as the key in `vmselect_service_envflag_data`:

```yaml
vmselect_service_envflag_data:
  storageNode: "vmstorage1,vmstorage2,vmstorage3"
  search_maxUniqueTimeseries: 900000  # corresponds to -search.maxUniqueTimeseries flag
```
