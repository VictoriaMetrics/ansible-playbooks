# vmauth

Role to install and configure vmauth. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

| Parameter                          | Description                                                                                                                | Default                                                                                            |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| vmauth_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                               |
| vmauth_version                     | vmauth version                                                                                                             | `v1.142.0`                                                                                         |
| vmauth_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                            |
| vmauth_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                               |
| vmauth_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                               |
| vmauth_download_url                | URL to download archive                                                                                                    | `{{ vmauth_repo_url }}/releases/download/{{ vmauth_version }}/vmutils-{{ vmauth_version }}.tar.gz` |
| vmauth_system_user                 | User to run vmauth                                                                                                         | `victoriametrics`                                                                                  |
| vmauth_system_group                | Group for user of vmauth                                                                                                   | `{{ vmauth_system_user }}`                                                                         |
| vmauth_service_state               | Default state of systemd service                                                                                           | `started`                                                                                          |
| vmauth_service_enabled             | Whether to enable systemd service                                                                                          | `true`                                                                                             |    
| vmauth_config_dir                  | Location for config files                                                                                                  | `/opt/victoriametrics-vmauth`                                                                      |
| vmauth_bin_dir                     | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                   |
| vmauth_config                      | Config parameters to be passed via environment variables                                                                   | `{}`                                                                                               |
| vmauth_exec_start_post             | Post start hook for systemd unit                                                                                           | `""`                                                                                               |
| vmauth_exec_stop                   | Stop command for systemd unit                                                                                              | `""`                                                                                               |
| vmauth_auth_config                 | vmauth authentication config.                                                                                              | See [defaults.yml](./defaults/main.yml)                                                            |
| vmauth_install_download_to_control | Whether use control or remote host to download installation archive                                                        | `true`                                                                                             |
| vmauth_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                            |
| vm_proxy_http                      | Sets environment for downloading archive                                                                                   | `""`                                                                                               |
| vm_proxy_https                     | Sets environment for downloading archive                                                                                   | `""`                                                                                               |

## Configuration via environment variables

This role configures vmauth using environment variables via `vmauth_config` with `-envflag.enable`. Additional flags can also be passed directly on the command line via `vmauth_service_args`.

For `vmauth_config` keys: each `.` in a flag name must be replaced with `_` when passed as an environment variable. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

For `vmauth_service_args` keys: dots can be used as-is since these are passed directly as command-line flags.

```yaml
vmauth_config:
  # envflag-based config: use _ instead of .
  http_pathPrefix: "/vm"  # corresponds to -http.pathPrefix flag

vmauth_service_args:
  # CLI flags: dots work as-is
  http.pathPrefix: "/vm"  # passed directly as --http.pathPrefix
```
