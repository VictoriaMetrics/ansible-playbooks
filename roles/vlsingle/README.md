# VL single

Installs VictoriaLogs single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                              | Description                                                                                                                         | Default                                                                                                                                                                                          |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| victorialogs_repo_url                  | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaLogs`                                                                                                                                             |
| victorialogs_version                   | Version to install                                                                                                                  | `v1.50.0`                                                                                                                                                                                         |
| victorialogs_download_url              | Resulting download url.                                                                                                             | `"{{ victorialogs_repo_url }}/releases/download/{{ victorialogs_version }}-victorialogs/victoria-logs-{{ victorialogs_platform }}-{{ go_arch }}-{{ victorialogs_version }}-victorialogs.tar.gz"` |
| victorialogs_system_user               | User to run service.                                                                                                                | `victorialogs`                                                                                                                                                                                |
| victorialogs_system_group              | Group to run service.                                                                                                               | `{{ victorialogs_system_user }}`                                                                                                                                                                 |
| victorialogs_data_dir                  | Directory to store data configs.                                                                                                    | `/var/lib/victoria-logs/`                                                                                                                                                                        |
| victorialogs_service_args              | Passes options defined above to VictoriaLogs single.                                                                                | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victorialogs_service_envflag_enabled   | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                                                                          |
| victorialogs_service_envflag_data      | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victorialogs_service_envflag_file      | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victorialogs_install_download_to_control | Whether use control or remote host to download archive                                                                               | `true`                                                                                                                                                                                           |
| vm_proxy_http                             | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |
| vm_proxy_https                            | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |

## Flag naming and environment variables

`victorialogs_service_args` keys are passed directly as command-line flags:

```yaml
victorialogs_service_args:
  storageDataPath: "/var/lib/victoria-logs/"
  "retention.maxDiskSpaceUsageBytes": "10GB"  # passed as -retention.maxDiskSpaceUsageBytes
```

When `victorialogs_service_envflag_enabled` is set to `true`, the `victorialogs_service_envflag_data` entries are passed as environment variables. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
victorialogs_service_envflag_enabled: "true"
victorialogs_service_envflag_data:
  - "retention_maxDiskSpaceUsageBytes=10GB"  # corresponds to -retention.maxDiskSpaceUsageBytes flag
```
