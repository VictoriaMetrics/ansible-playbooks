# VLagent

Role to install and configure vlagent. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Description                                                                                                                | Default                                                                                               |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vlagent_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaLogs`                                                     |
| vlagent_version                     | vlagent version                                                                                                            | `v1.52.0`                                                                                             |
| vlagent_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                               |
| vlagent_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                  |
| vlagent_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                  |
| vlagent_service_name                | Name of the installed system service                                                                                       | `vic-vlagent`                                                                                         |
| vlagent_download_url                | URL to download archive                                                                                                    | `{{ vlagent_repo_url }}/releases/download/{{ vlagent_version }}/vlutils{{ vlagent_platform }}-{{ go_arch }}-{{ vlagent_version }}.tar.gz` |
| vlagent_system_user                 | User to run vlagent                                                                                                        | `vic_vl_agent`                                                                                        |
| vlagent_system_group                | Group for user of vlagent                                                                                                  | `{{ vlagent_system_user }}`                                                                           |
| vlagent_remote_write_host           | Remote write host URL.                                                                                                     | `http://localhost:9428`                                                                               |
| vlagent_service_args                | Dict representing set of arguments for vlagent                                                                             | See [defaults](defaults/main.yml)                                                                     |
| vlagent_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                      |
| vlagent_install_download_to_control | Whether use control or remote host to download installation archive                                                        | false                                                                                                 |
| vlagent_exec_start_post             | Post start hook for systemd unit.                                                                                         | `""`                                                                                                  |
| vlagent_exec_stop                   | Stop command for systemd unit.                                                                                            | `""`                                                                                                  |
| vlagent_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                               |
| vlagent_service_envflag_enabled     | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) | `"false"`                                                             |
| vlagent_service_envflag_data        | Flags data to pass to service                                                                                              | `[]`                                                                                                  |
| vlagent_service_envflag_file        | Location of env file to include for service.                                                                               | `/etc/default/{{ vlagent_service_name }}`                                                             |
| vm_proxy_http                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |

## Deprecated aliases

The `vl_proxy_*` variable names are deprecated in favor of the unified `vm_proxy_*` prefix (shared with the other roles) and will be removed in a future release. Old names still work (each is used as a fallback when the corresponding new name is unset), and the role emits a deprecation warning when it detects one. Migrate to the new names:

| Deprecated    | Use instead   |
|---------------|---------------|
| vl_proxy_http | vm_proxy_http |
| vl_proxy_https | vm_proxy_https |

## Flag naming

`vlagent_service_args` keys are passed directly as command-line flags:

```yaml
vlagent_service_args:
  remoteWrite.url: "http://localhost:9428/insert/jsonline"
  remoteWrite.tmpDataPath: "/var/lib/vlagent-remotewrite-data"
```

## Configuration via environment variables

When `vlagent_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line, renders every `vlagent_service_envflag_data` entry as an `Environment=` line and includes `vlagent_service_envflag_file` as an `EnvironmentFile=`. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vlagent_service_envflag_enabled: "true"
vlagent_service_envflag_data:
  - "remoteWrite_maxDiskUsagePerURL=1GB"  # corresponds to -remoteWrite.maxDiskUsagePerURL flag
```

Command-line flags win: the upstream `-envflag.enable` description states that "Command line flag values have priority over values from environment vars". Since the role renders every `vlagent_service_args` entry onto the command line, environment variables are only useful for flags that are not in `vlagent_service_args`.

Each `vlagent_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and which contains no `"`. The role asserts this and fails the play on any entry that does not match. The check exists because a newline inside an entry closes the generated `Environment=` line and the remainder is written into the unit file as further systemd directives - a smuggled `User=root` would override the `User=` the role renders above it and run the service as root. A `"` breaks the same line without needing a newline. Values are subject to systemd specifier expansion, so a literal `%` must be written as `%%`.

### The env file

The env file path follows `vlagent_service_name`, so renamed instances get their own file. The role creates it empty at mode `0644` owned by `root:root` only if it does not exist yet, and never rewrites its contents or permissions afterwards. Its parent directory is not created for you: pointing `vlagent_service_envflag_file` at a path under a directory that does not exist fails the play with `Error, could not touch target: [Errno 2] No such file or directory`.

`Environment=` values are stored in the unit file, which is world-readable at mode `0644`. Put secrets in `vlagent_service_envflag_file` instead - but the role creates that file world-readable too, so `chmod 0600` it **before** writing any secret into it. systemd reads `EnvironmentFile=` as PID 1, so `0600 root:root` does not prevent the service from picking the values up.

Further caveats:

- `EnvironmentFile=` is rendered without systemd's `-` prefix, so the unit fails to start if the file is deleted while envflag is enabled.
- The role never reads the env file back, so editing it out of band does not notify the restart handler. Restart the service yourself after changing it.
- A key set in the env file overrides the same key set through `vlagent_service_envflag_data`: per `systemd.exec(5)`, "Settings from these files override settings made with `Environment=`".
