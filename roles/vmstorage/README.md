# vmstorage

Role to install and configure vmstorage. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                             | Description                                                                                                                | Default                                                                                                     |
|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| vmstorage_version                     | vmstorage version                                                                                                          | `v1.151.0`                                                                                                  |
| vmstorage_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                                     |
| vmstorage_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                        |
| vmstorage_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                        |
| vmstorage_service_name                | Name of the installed system service                                                                                       | `vmstorage`                                                                                                 |
| vmstorage_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                        |
| vmstorage_download_url                | URL to download archive                                                                                                    | `{{ vmstorage_repo_url }}/releases/download/{{ vmstorage_version }}/victoria-metrics{{ vmstorage_platform }}-{{ go_arch }}-{{ vmstorage_version }}-cluster.tar.gz` |
| vmstorage_system_user                 | User to run vmstorage                                                                                                      | `victoriametrics`                                                                                           |
| vmstorage_system_group                | Group for user of vmstorage                                                                                                | `{{ vmstorage_system_user }}`                                                                               |
| vmstorage_service_state               | Default state of systemd service                                                                                           | `started`                                                                                                   |
| vmstorage_service_enabled             | Whether to enable systemd service                                                                                          | `true`                                                                                                      |    
| vmstorage_retention_period            | Set retentionPeriod value                                         |                                                      `1`                                                                     |
| vmstorage_config_dir                  | Location for config files                                                                                                  | `/opt/victoriametrics-vmstorage`                                                                            |
| vmstorage_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                            |
| vmstorage_service_envflag_enabled     | Pass config parameters via environment variables using `-envflag.enable`                                                   | `true`                                                                                                      |
| vmstorage_service_envflag_data        | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                     |
| vmstorage_service_envflag_data_file   | Role-managed env file holding the entries above. Rewritten on every run.                                                   | `{{ vmstorage_config_dir }}/vmstorage.conf`                                                                 |
| vmstorage_service_envflag_file        | User-managed env file, read after the role-managed one so its keys win.                                                    | `/etc/default/{{ vmstorage_service_name }}`                                                                 |
| vmstorage_service_args                | Extra command-line flags for vmstorage, passed as-is.                                                                      | `{}`                                                                                                        |
| vmstorage_data_dir                    | Data directory to use for vmstorage                                                                                        | `"/var/lib/vmstorage"`                                                                                      |
| vmstorage_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                        |
| vmstorage_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                        |
| vmstorage_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                      |
| vmstorage_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                     |
| vm_proxy_http                         | Sets environment for downloading archive                                                                                   | `""`                                                                                                        |
| vm_proxy_https                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                        |

## Deprecated aliases

`vmstorage_config` is deprecated in favor of `vmstorage_service_envflag_data`, which matches the naming used by the other roles, and will be removed in a future release. The old name still works (it is used as a fallback when the new name is unset), and the role emits a deprecation warning when it detects it. Migrate to the new name:

| Deprecated       | Use instead                    |
|------------------|--------------------------------|
| vmstorage_config | vmstorage_service_envflag_data |

## Configuration via environment variables

By default this role configures vmstorage using environment variables via `vmstorage_service_envflag_data` with `-envflag.enable`. Additional flags can also be passed directly on the command line via `vmstorage_service_args`.

For `vmstorage_service_envflag_data` keys: each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vmstorage_service_envflag_data_file` | `{{ vmstorage_config_dir }}/vmstorage.conf` | the role, rewritten on every run | `vmstorage_service_envflag_data` |
| `vmstorage_service_envflag_file` | `/etc/default/{{ vmstorage_service_name }}` | you | anything you put there |

The role rewrites the first file on every run and lists it in the unit before the second, so a key set in your file overrides the same key coming from `vmstorage_service_envflag_data`. Put secrets in `vmstorage_service_envflag_file` - the role never reads or rewrites it. The two paths must differ, and the role asserts it. Both files are kept at mode `0600` owned by `root:root`.

The role asserts that every `vmstorage_service_envflag_data` key matches `[A-Za-z_][A-Za-z0-9_]*` and that every value is single-line and free of `'`, reporting the offending keys but never the values, which can hold secrets.

Entries are written as `KEY='value'`, so values reach the binary literally. Earlier releases wrote them unquoted and systemd applied shell backslash rules - if you were doubling backslashes in `vmstorage_service_envflag_data` to compensate, drop the doubling.

For `vmstorage_service_args` keys: dots can be used as-is since these are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values.

```yaml
vmstorage_service_envflag_data:
  # envflag-based config: use _ instead of .
  retentionPeriod: 1
  storageDataPath: "/var/lib/vmstorage"
  storage_minFreeDiskSpaceBytes: "1GB"  # corresponds to -storage.minFreeDiskSpaceBytes flag

vmstorage_service_args:
  # CLI flags: dots work as-is
  storage.minFreeDiskSpaceBytes: "1GB"  # passed directly as --storage.minFreeDiskSpaceBytes
```

Setting `vmstorage_service_envflag_enabled: false` drops both `-envflag.enable` and the env file from the unit, so all configuration must go through `vmstorage_service_args`. The role fails if `vmstorage_service_envflag_data` is non-empty in that case, since those parameters would be silently ignored - set it to `{}` explicitly.
