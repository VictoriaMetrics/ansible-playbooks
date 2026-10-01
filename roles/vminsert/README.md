# vminsert

Role to install and configure vminsert. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                            | Description                                                                                                                | Default                                                                                                  |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| vminsert_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                     |
| vminsert_version                     | vminsert version                                                                                                           | `v1.148.0`                                                                                               |
| vminsert_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                                  |
| vminsert_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                     |
| vminsert_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                     |
| vminsert_service_name                | Name of the installed system service                                                                                       | `vminsert`                                                                                               |
| vminsert_download_url                | URL to download archive                                                                                                    | `{{ vminsert_repo_url }}/releases/download/{{ vminsert_version }}/victoria-metrics{{ vminsert_platform }}-{{ go_arch }}-{{ vminsert_version }}-cluster.tar.gz` |
| vminsert_system_user                 | User to run vminsert                                                                                                       | `victoriametrics`                                                                                        |
| vminsert_system_group                | Group for user of vminsert                                                                                                 | `{{ vminsert_system_user }}`                                                                             |
| vminsert_service_state               | Default state of systemd service                                                                                           | `started`                                                                                                |
| vminsert_service_enabled             | Whether to enable systemd service                                                                                          | `true`                                                                                                   |    
| vminsert_config_dir                  | Location for config files                                                                                                  | `/opt/victoriametrics-vminsert`                                                                          |
| vminsert_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                         |
| vminsert_service_envflag_data        | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                  |
| vminsert_relabel_config              | Relabeling configuration for vminsert                                                                                      | `""`                                                                                                     |
| vminsert_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                     |
| vminsert_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                     |
| vminsert_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                   |
| vminsert_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                  |
| vm_proxy_http                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |
| vm_proxy_https                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |

## Deprecated aliases

`vminsert_config` is deprecated in favor of `vminsert_service_envflag_data`, which matches the naming used by the other roles, and will be removed in a future release. The old name still works (it is used as a fallback when the new name is unset), and the role emits a deprecation warning when it detects it. It is accepted as input only: the role no longer defines `vminsert_config` as a default, so a playbook that reads it after the role (for example `{{ vminsert_config.storageNode }}`) must read `vminsert_service_envflag_data` instead. [playbooks/cluster.yml](../../playbooks/cluster.yml) sets `vminsert_service_envflag_data` as a play var, so `-e vminsert_config=...` no longer has any effect on that playbook - pass `-e vminsert_service_envflag_data=...` instead. Migrate to the new name:

| Deprecated      | Use instead                   |
|-----------------|-------------------------------|
| vminsert_config | vminsert_service_envflag_data |

## Configuration via environment variables

This role configures vminsert using environment variables with `-envflag.enable`. Each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

For example, to set the `-insert.maxQueueDuration` flag, use `insert_maxQueueDuration` as the key in `vminsert_service_envflag_data`:

```yaml
vminsert_service_envflag_data:
  replicationFactor: 1
  storageNode: "vmstorage1,vmstorage2,vmstorage3"
  insert_maxQueueDuration: "1m"  # corresponds to -insert.maxQueueDuration flag
```
