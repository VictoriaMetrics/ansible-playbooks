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
| vminsert_service_envflag_enabled     | Pass config parameters via environment variables using `-envflag.enable`                                                   | `true`                                                                                                   |
| vminsert_service_envflag_data        | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                  |
| vminsert_service_envflag_file        | Location of env file to include for service.                                                                               | `{{ vminsert_config_dir }}/vminsert.conf`                                                                |
| vminsert_service_args                | Extra command-line flags for vminsert, passed as-is.                                                                       | `{}`                                                                                                     |
| vminsert_relabel_config              | Relabeling configuration for vminsert                                                                                      | `""`                                                                                                     |
| vminsert_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                     |
| vminsert_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                     |
| vminsert_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                   |
| vminsert_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                  |
| vm_proxy_http                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |
| vm_proxy_https                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |

## Deprecated aliases

`vminsert_config` is deprecated in favor of `vminsert_service_envflag_data`, which matches the naming used by the other roles, and will be removed in a future release. The old name still works (it is used as a fallback when the new name is unset), and the role emits a deprecation warning when it detects it. Migrate to the new name:

| Deprecated      | Use instead                   |
|-----------------|-------------------------------|
| vminsert_config | vminsert_service_envflag_data |

## Configuration via environment variables

By default this role configures vminsert using environment variables via `vminsert_service_envflag_data` with `-envflag.enable`. Additional flags can also be passed directly on the command line via `vminsert_service_args`.

For `vminsert_service_envflag_data` keys: each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

For `vminsert_service_args` keys: dots can be used as-is since these are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values.

```yaml
vminsert_service_envflag_data:
  # envflag-based config: use _ instead of .
  replicationFactor: 1
  storageNode: "vmstorage1,vmstorage2,vmstorage3"
  insert_maxQueueDuration: "1m"  # corresponds to -insert.maxQueueDuration flag

vminsert_service_args:
  # CLI flags: dots work as-is
  insert.maxQueueDuration: "1m"  # passed directly as --insert.maxQueueDuration
  # a list renders the flag once per item
  storageNode:
    - "vmstorage1"
    - "vmstorage2"
```

Setting `vminsert_service_envflag_enabled: false` drops both `-envflag.enable` and the env file from the unit, so all configuration must go through `vminsert_service_args`. The role fails if `vminsert_service_envflag_data` is non-empty in that case, since those parameters would be silently ignored - set it to `{}` explicitly. `vminsert_relabel_config` keeps working: the `relabelConfig` flag moves to `vminsert_service_args` automatically.
