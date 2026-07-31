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
| vminsert_service_envflag_data_file   | Role-managed env file holding the entries above. Rewritten on every run.                                                   | `{{ vminsert_config_dir }}/vminsert.conf`                                                                |
| vminsert_service_envflag_file        | User-managed env file, read after the role-managed one so its keys win.                                                    | `/etc/default/{{ vminsert_service_name }}`                                                               |
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

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vminsert_service_envflag_data_file` | `{{ vminsert_config_dir }}/vminsert.conf` | the role, rewritten on every run | `vminsert_service_envflag_data` |
| `vminsert_service_envflag_file` | `/etc/default/{{ vminsert_service_name }}` | you | anything you put there |

The role renders `vminsert_service_envflag_data` into the first file and lists it in the unit before the second, so a key set in your file overrides the same key coming from `vminsert_service_envflag_data`: per `systemd.exec(5)`, when the same variable is set twice "the files will be read in the order they are specified and the later setting will override the earlier setting".

Both are created at mode `0600` owned by `root:root`; systemd reads `EnvironmentFile=` as PID 1, so that does not prevent the service from picking the values up. Put secrets in `vminsert_service_envflag_file` - it is the file the role never reads or rewrites, so a secret written there survives every subsequent run.

The role asserts that every `vminsert_service_envflag_data` key matches `[A-Za-z_][A-Za-z0-9_]*` and that every value is single-line and free of `'`, failing the play otherwise. It reports the offending keys but never the values, which can hold secrets. Two reasons for the check:

- Entries are written as `KEY='value'`. systemd recognizes no escape sequences inside single quotes, so a `'` in the value terminates it early and corrupts the rest of the line. Values needing a literal `'` go in `vminsert_service_envflag_file`, where you control the quoting.
- systemd drops an `EnvironmentFile=` assignment whose name it rejects - it logs `Ignoring invalid environment assignment` and starts the service anyway - so a `.` left in a key would be silently unapplied rather than reported as an error.

Single-quoting is also what makes values literal. Earlier releases wrote `KEY=value` unquoted, where systemd applies POSIX shell backslash rules: a value of `\d+` reached the binary as `d+`, and a trailing `\` swallowed the following line. Backslashes now reach the binary as written, which is what regex-valued flags need. If you were compensating by doubling backslashes in `vminsert_service_envflag_data`, drop the doubling.

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
