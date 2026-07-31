# VMagent

Role to install and configure vmagent. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

> Note that default `vmagent_remote_write_host` is using port for VMSingle installation. For cluster mode installed
> by using roles from this repository it is needed to point at VMSelect component which will be placed behind a load balancer.
> See [playbooks/cluster.yaml](../../playbooks/cluster.yml) for cluster deployment example.

| Parameter                           | Description                                                                                                                | Default                                                                                               |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vmagent_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                  |
| vmagent_version                     | vmagent version                                                                                                            | `v1.148.0`                                                                                            |
| vmagent_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                               |
| vmagent_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                  |
| vmagent_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                  |
| vmagent_service_name                | Name of the installed system service                                                                                       | `vic-vmagent`                                                                                         |
| vmagent_download_url                | URL to download archive                                                                                                    | `{{ vmagent_repo_url }}/releases/download/{{ vmagent_version }}/vmutils{{ vmagent_platform }}-{{ go_arch }}-{{ vmagent_version }}.tar.gz` |
| vmagent_system_user                 | User to run vmagent                                                                                                        | `vic_vm_agent`                                                                                        |
| vmagent_system_group                | Group for user of vmagent                                                                                                  | `{{ vmagent_system_user }}`                                                                           |
| vmagent_bin_dir                      | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                      |
| vmagent_config_dir                  | Path where configuration will be stored.                                                                                   | `/opt/vic-vmagent`                                                                                    |
| vmagent_sd_config_dir               | Path to directory to configure file_sd.                                                                                    | `{{ vmagent_config_dir }}/file_sd_configs`                                                            |
| vmagent_remote_write_host           | Remote write host URL.                                                                                                     | `http://localhost:8428`                                                                               |
| vmagent_tmp_data_path               | Path for buffering data before it is sent to remote storage (`remoteWrite.tmpDataPath`).                                   | `/tmp/vmagent`                                                                                        |
| vmagent_service_args                | Dict representing set of arguments for vmagent                                                                             | See [defaults](defaults/main.yml)                                                                     |
| vmagent_scrape_config               | Prometheus scrape configuration                                                                                            | See [defaults](defaults/main.yml)                                                                     |
| vmagent_aggregation_config          | Stream aggregation configuration                                                                                           | []                                                                                                    |
| vmagent_install_download_to_control | Whether use control or remote host to download installation archive                                                        | false                                                                                                  |
| vmagent_exec_start_post             | Post start hook for systemd unit.                                                                                         | `""`                                                                                                  |
| vmagent_exec_stop                   | Stop command for systemd unit.                                                                                            | `""`                                                                                                  |
| vmagent_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                               |
| vmagent_service_envflag_enabled     | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) | `"false"`                                                             |
| vmagent_service_envflag_data        | Flags data to pass to service                                                                                              | `[]`                                                                                                  |
| vmagent_service_envflag_file        | Location of env file to include for service.                                                                               | `/etc/default/{{ vmagent_service_name }}`                                                             |
| vm_proxy_http                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |

## Flag naming

`vmagent_service_args` keys are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values:

```yaml
vmagent_service_args:
  promscrape.config: "/opt/vic-vmagent/scrape.yml"
  remoteWrite.url: "http://localhost:8428/api/v1/write"
  remoteWrite.tmpDataPath: "/var/lib/vmagent-remotewrite-data"
```

## Configuration via environment variables

When `vmagent_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line and lists two `EnvironmentFile=` entries in the unit. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vmagent_service_envflag_enabled: "true"
vmagent_service_envflag_data:
  - "remoteWrite_maxDiskUsagePerURL=1GB"  # corresponds to -remoteWrite.maxDiskUsagePerURL flag
```

Command-line flags win: the upstream `-envflag.enable` description states that "Command line flag values have priority over values from environment vars". Since the role renders every `vmagent_service_args` entry onto the command line, environment variables are only useful for flags that are not in `vmagent_service_args`.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vmagent_service_envflag_data_file` | `/etc/default/{{ vmagent_service_name }}.env` | the role, rewritten on every run | `vmagent_service_envflag_data` |
| `vmagent_service_envflag_file` | `/etc/default/{{ vmagent_service_name }}` | you | anything you put there |

The role renders `vmagent_service_envflag_data` into the first file and lists it before the second, so a key set in your file overrides the same key coming from `vmagent_service_envflag_data`: per `systemd.exec(5)`, when the same variable is set twice "the files will be read in the order they are specified and the later setting will override the earlier setting".

Both paths follow `vmagent_service_name`, so renamed instances get their own files. Both are created at mode `0600` owned by `root:root`; systemd reads `EnvironmentFile=` as PID 1, so that does not prevent the service from picking the values up. Neither parent directory is created for you: pointing either variable at a path under a directory that does not exist fails the play with `Error, could not touch target: [Errno 2] No such file or directory`.

Put secrets in `vmagent_service_envflag_file`. It is the file the role never reads or rewrites, so a secret written there survives every subsequent run. `vmagent_service_envflag_data` is regular inventory data - it ends up in the role-managed file at `0600`, but it also lives wherever your inventory lives.

Each `vmagent_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and whose value contains no `'`. The role asserts this and fails the play on any entry that does not match, reporting the 1-based positions of the offending entries rather than their contents, since values can hold secrets. Two reasons for the check:

- The role writes each entry as `KEY='value'`. systemd recognizes no escape sequences inside single quotes, so a `'` in the value terminates it early and corrupts the rest of the line. Values needing a literal `'` go in `vmagent_service_envflag_file`, where you control the quoting.
- systemd silently drops an assignment whose variable name it rejects - it logs `Ignoring invalid environment assignment` and starts the service anyway - so a `.` left in a key would never be applied and never reported as an error.

Single-quoting is also what makes values literal: `%` needs no doubling, and `\` reaches the binary as written, which is what regex-valued flags need.

Further caveats:

- Both `EnvironmentFile=` entries are rendered without systemd's `-` prefix, so the unit fails to start if either file is deleted while envflag is enabled.
- The role never reads `vmagent_service_envflag_file` back, so editing it out of band does not notify the restart handler. Restart the service yourself after changing it.
- Flipping `vmagent_service_envflag_enabled` back to `false` leaves both files on disk; the unit simply stops referencing them.
