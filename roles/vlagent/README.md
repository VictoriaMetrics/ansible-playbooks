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

`vlagent_service_args` keys are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values:

```yaml
vlagent_service_args:
  remoteWrite.url: "http://localhost:9428/insert/jsonline"
  remoteWrite.tmpDataPath: "/var/lib/vlagent-remotewrite-data"
```

## Configuration via environment variables

When `vlagent_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line and lists two `EnvironmentFile=` entries in the unit. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vlagent_service_envflag_enabled: "true"
vlagent_service_envflag_data:
  - "remoteWrite_maxDiskUsagePerURL=1GB"  # corresponds to -remoteWrite.maxDiskUsagePerURL flag
```

Command-line flags win over environment variables, and the role renders every `vlagent_service_args` entry onto the command line, so environment variables only help for flags that are not in `vlagent_service_args`.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vlagent_service_envflag_data_file` | `/etc/default/{{ vlagent_service_name }}.env` | the role, rewritten on every run | `vlagent_service_envflag_data` |
| `vlagent_service_envflag_file` | `/etc/default/{{ vlagent_service_name }}` | you | anything you put there |

The role rewrites the first file on every run and lists it before the second, so a key set in your file overrides the same key coming from `vlagent_service_envflag_data`. Put secrets in `vlagent_service_envflag_file` - the role never reads or rewrites it. The two paths must differ, and the role asserts it. Both files are kept at mode `0600` owned by `root:root`; neither parent directory is created for you.

Each `vlagent_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and whose value contains no `'`. The role asserts this and reports the 1-based positions of the offending entries rather than their values, which can hold secrets.

Editing `vlagent_service_envflag_file` out of band does not notify the restart handler - restart the service yourself after changing it.
