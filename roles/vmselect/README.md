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
| vmselect_service_envflag_enabled     | Pass config parameters via environment variables using `-envflag.enable`                                                   | `true`                                                                                                   |
| vmselect_service_envflag_data        | Config parameters to be passed via environment variables                                                                   | See [defaults.yml](./defaults/main.yml)                                                                  |
| vmselect_service_envflag_data_file   | Role-managed env file holding the entries above. Rewritten on every run.                                                   | `{{ vmselect_config_dir }}/vmselect.conf`                                                                |
| vmselect_service_envflag_file        | User-managed env file, read after the role-managed one so its keys win.                                                    | `/etc/default/{{ vmselect_service_name }}`                                                               |
| vmselect_service_args                | Extra command-line flags for vmselect, passed as-is.                                                                       | `{}`                                                                                                     |
| vmselect_cache_dir                   | Cache directory to use for vmselect's cache                                                                                | `"/var/lib/vmselect"`                                                                                    |
| vmselect_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                                     |
| vmselect_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                                     |
| vmselect_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `false`                                                                                                   |
| vmselect_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                                  |
| vm_proxy_http                        | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |
| vm_proxy_https                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                     |

## Deprecated aliases

`vmselect_config` is deprecated in favor of `vmselect_service_envflag_data`, which matches the naming used by the other roles, and will be removed in a future release. The old name still works (it is used as a fallback when the new name is unset), and the role emits a deprecation warning when it detects it. Migrate to the new name:

| Deprecated      | Use instead                   |
|-----------------|-------------------------------|
| vmselect_config | vmselect_service_envflag_data |

## Configuration via environment variables

By default this role configures vmselect using environment variables via `vmselect_service_envflag_data` with `-envflag.enable`. Additional flags can also be passed directly on the command line via `vmselect_service_args`.

For `vmselect_service_envflag_data` keys: each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vmselect_service_envflag_data_file` | `{{ vmselect_config_dir }}/vmselect.conf` | the role, rewritten on every run | `vmselect_service_envflag_data` |
| `vmselect_service_envflag_file` | `/etc/default/{{ vmselect_service_name }}` | you | anything you put there |

The role rewrites the first file on every run and lists it in the unit before the second, so a key set in your file overrides the same key coming from `vmselect_service_envflag_data`. Put secrets in `vmselect_service_envflag_file` - the role never reads or rewrites it. The two paths must differ, and the role asserts it. Both files are kept at mode `0600` owned by `root:root`.

The role asserts that every `vmselect_service_envflag_data` key matches `[A-Za-z_][A-Za-z0-9_]*` and that every value is single-line and free of `'`, reporting the offending keys but never the values, which can hold secrets.

Entries are written as `KEY='value'`, so values reach the binary literally. Earlier releases wrote them unquoted and systemd applied shell backslash rules - if you were doubling backslashes in `vmselect_service_envflag_data` to compensate, drop the doubling.

For `vmselect_service_args` keys: dots can be used as-is since these are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values.

```yaml
vmselect_service_envflag_data:
  # envflag-based config: use _ instead of .
  storageNode: "vmstorage1,vmstorage2,vmstorage3"
  search_maxUniqueTimeseries: 900000  # corresponds to -search.maxUniqueTimeseries flag

vmselect_service_args:
  # CLI flags: dots work as-is
  search.maxUniqueTimeseries: 900000  # passed directly as --search.maxUniqueTimeseries
  # a list renders the flag once per item
  storageNode:
    - "vmstorage1"
    - "vmstorage2"
```

Setting `vmselect_service_envflag_enabled: false` drops both `-envflag.enable` and the env file from the unit, so all configuration must go through `vmselect_service_args`. The role fails if `vmselect_service_envflag_data` is non-empty in that case, since those parameters would be silently ignored - set it to `{}` explicitly.
