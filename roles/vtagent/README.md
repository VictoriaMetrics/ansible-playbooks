# VTagent

Role to install and configure [vtagent](https://docs.victoriametrics.com/victoriatraces/vtagent/). Installs by using binary from Github releases.

vtagent accepts trace spans over OTLP/HTTP on port `10429` and forwards them to VictoriaTraces. The `vtutils` archive which ships `vtagent` is published starting from VictoriaTraces `v0.11.0`.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                           | Description                                                                                                                | Default                                                                                               |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vtagent_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaTraces`                                                   |
| vtagent_version                     | vtagent version                                                                                                            | `v0.13.0`                                                                                             |
| vtagent_service_name                | Name of the installed system service                                                                                       | `vic-vtagent`                                                                                         |
| vtagent_download_url                | URL to download archive                                                                                                    | `{{ vtagent_repo_url }}/releases/download/{{ vtagent_version }}/vtutils{{ vtagent_platform }}-{{ go_arch }}-{{ vtagent_version }}.tar.gz` |
| vtagent_system_user                 | User to run vtagent                                                                                                        | `vic_vt_agent`                                                                                        |
| vtagent_system_group                | Group for user of vtagent                                                                                                  | `{{ vtagent_system_user }}`                                                                           |
| vtagent_tmp_data_path               | Path for buffering data before it is sent to remote storage (`remoteWrite.tmpDataPath`).                                   | `/tmp/vtagent`                                                                                        |
| vtagent_remote_write_host           | Remote write host URL.                                                                                                     | `http://localhost:10428`                                                                              |
| vtagent_service_args                | Dict representing set of arguments for vtagent                                                                             | See [defaults](defaults/main.yml)                                                                     |
| vtagent_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                      |
| vtagent_install_download_to_control | Whether use control or remote host to download installation archive                                                        | false                                                                                                 |
| vtagent_exec_start_post             | Post start hook for systemd unit.                                                                                         | `""`                                                                                                  |
| vtagent_exec_stop                   | Stop command for systemd unit.                                                                                            | `""`                                                                                                  |
| vtagent_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                               |
| vtagent_service_envflag_enabled     | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) | `"false"`                                                             |
| vtagent_service_envflag_data        | Flags data to pass to service                                                                                              | `[]`                                                                                                  |
| vtagent_service_envflag_data_file   | Role-managed env file holding the entries above. Rewritten on every run.                                                   | `/etc/default/{{ vtagent_service_name }}.env`                                                         |
| vtagent_service_envflag_file        | User-managed env file, read after the role-managed one so its keys win.                                                    | `/etc/default/{{ vtagent_service_name }}`                                                             |
| vm_proxy_http                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |

VictoriaTraces has no Enterprise version, so the role has no `_enterprise` or license variables.

## Flag naming

`vtagent_service_args` keys are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values:

```yaml
vtagent_tmp_data_path: "/var/lib/vtagent-remotewrite-data"
vtagent_service_args:
  remoteWrite.url:
    - "http://victoria-traces-1:10428/insert/opentelemetry/v1/traces"
    - "http://victoria-traces-2:10428/insert/opentelemetry/v1/traces"
  remoteWrite.tmpDataPath: "{{ vtagent_tmp_data_path }}"
```

The role creates `vtagent_tmp_data_path` owned by `vtagent_system_user`, so set the buffer location through that variable rather than as a literal path in `vtagent_service_args`.

`-remoteWrite.url` must point to an OTLP/HTTP traces endpoint. See [vtagent docs](https://docs.victoriametrics.com/victoriatraces/vtagent/) for the full list of flags.

## Configuration via environment variables

When `vtagent_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line and lists two `EnvironmentFile=` entries in the unit. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vtagent_service_envflag_enabled: "true"
vtagent_service_envflag_data:
  - "remoteWrite_maxDiskUsagePerURL=1GB"  # corresponds to -remoteWrite.maxDiskUsagePerURL flag
```

Command-line flags win over environment variables, and the role renders every `vtagent_service_args` entry onto the command line, so environment variables only help for flags that are not in `vtagent_service_args`.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vtagent_service_envflag_data_file` | `/etc/default/{{ vtagent_service_name }}.env` | the role, rewritten on every run | `vtagent_service_envflag_data` |
| `vtagent_service_envflag_file` | `/etc/default/{{ vtagent_service_name }}` | you | anything you put there |

The role rewrites the first file on every run and lists it before the second, so a key set in your file overrides the same key coming from `vtagent_service_envflag_data`. Put secrets in `vtagent_service_envflag_file` - the role never reads or rewrites it. The two paths must differ, and the role asserts it. Both files are kept at mode `0600` owned by `root:root`; neither parent directory is created for you.

Each `vtagent_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and whose value contains no `'`. The role asserts this and reports the 1-based positions of the offending entries rather than their values, which can hold secrets.

Editing `vtagent_service_envflag_file` out of band does not notify the restart handler - restart the service yourself after changing it.
