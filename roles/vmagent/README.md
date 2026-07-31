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

`vmagent_service_args` keys are passed directly as command-line flags:

```yaml
vmagent_service_args:
  promscrape.config: "/opt/vic-vmagent/scrape.yml"
  remoteWrite.url: "http://localhost:8428/api/v1/write"
  remoteWrite.tmpDataPath: "/var/lib/vmagent-remotewrite-data"
```

## Configuration via environment variables

When `vmagent_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line, renders every `vmagent_service_envflag_data` entry as an `Environment=` line and includes `vmagent_service_envflag_file` as an `EnvironmentFile=`. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vmagent_service_envflag_enabled: "true"
vmagent_service_envflag_data:
  - "remoteWrite_maxDiskUsagePerURL=1GB"  # corresponds to -remoteWrite.maxDiskUsagePerURL flag
```

Command-line flags win: the upstream `-envflag.enable` description states that "Command line flag values have priority over values from environment vars". Since the role renders every `vmagent_service_args` entry onto the command line, environment variables are only useful for flags that are not in `vmagent_service_args`.

Each `vmagent_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and which contains no `"`. The role asserts this and fails the play on any entry that does not match. The check exists because a newline inside an entry closes the generated `Environment=` line and the remainder is written into the unit file as further systemd directives - a smuggled `User=root` would override the `User=` the role renders above it and run the service as root. A `"` breaks the same line without needing a newline. Values are subject to systemd specifier expansion, so a literal `%` must be written as `%%`.

### The env file

The env file path follows `vmagent_service_name`, so renamed instances get their own file. The role creates it empty at mode `0644` owned by `root:root` only if it does not exist yet, and never rewrites its contents or permissions afterwards. Its parent directory is not created for you: pointing `vmagent_service_envflag_file` at a path under a directory that does not exist fails the play with `Error, could not touch target: [Errno 2] No such file or directory`.

`Environment=` values are stored in the unit file, which is world-readable at mode `0644`. Put secrets in `vmagent_service_envflag_file` instead - but the role creates that file world-readable too, so `chmod 0600` it **before** writing any secret into it. systemd reads `EnvironmentFile=` as PID 1, so `0600 root:root` does not prevent the service from picking the values up.

Further caveats:

- `EnvironmentFile=` is rendered without systemd's `-` prefix, so the unit fails to start if the file is deleted while envflag is enabled.
- The role never reads the env file back, so editing it out of band does not notify the restart handler. Restart the service yourself after changing it.
- A key set in the env file overrides the same key set through `vmagent_service_envflag_data`: per `systemd.exec(5)`, "Settings from these files override settings made with `Environment=`".
