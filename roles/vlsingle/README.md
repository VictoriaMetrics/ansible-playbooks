# VL single

Installs VictoriaLogs single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                              | Description                                                                                                                         | Default                                                                                                                                                                                          |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| vlsingle_repo_url                      | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaLogs`                                                                                                                                             |
| vlsingle_version                       | Version to install                                                                                                                  | `v1.52.0`                                                                                                                                                                                         |
| vlsingle_enterprise                    | Whether to use enterprise version of binaries.                                                                                     | `false`                                                                                                                                                                                          |
| vlsingle_license_key                   | License key for VictoriaMetrics enterprise.                                                                                        | `""`                                                                                                                                                                                            |
| vlsingle_license_key_file              | License key file for VictoriaMetrics enterprise.                                                                                   | `""`                                                                                                                                                                                            |
| vlsingle_download_url                  | Resulting download url.                                                                                                             | `"{{ vlsingle_repo_url }}/releases/download/{{ vlsingle_version }}/victoria-logs-{{ vlsingle_platform }}-{{ go_arch }}-{{ vlsingle_version }}{{ '-enterprise' if vlsingle_enterprise else '' }}.tar.gz"` |
| vlsingle_system_user                   | User to run service.                                                                                                                | `victorialogs`                                                                                                                                                                                |
| vlsingle_system_group                  | Group to run service.                                                                                                               | `{{ vlsingle_system_user }}`                                                                                                                                                                 |
| vlsingle_data_dir                      | Directory to store data configs.                                                                                                    | `/var/lib/victoria-logs/`                                                                                                                                                                        |
| vlsingle_retention_period              | Data retention period, passed verbatim to VictoriaLogs as `-retentionPeriod`. With no unit suffix the value is counted in months; see the [retention docs](https://docs.victoriametrics.com/victorialogs/#retention) for the supported unit suffixes. | `12`                                                                                                                                                                                            |
| vlsingle_max_open_files                | Open files limit for the service (systemd `LimitNOFILE`).                                                                          | `2097152`                                                                                                                                                                                       |
| vlsingle_service_args                  | Passes options defined above to VictoriaLogs single.                                                                                | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vlsingle_service_envflag_enabled       | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                                                                          |
| vlsingle_service_envflag_data          | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vlsingle_service_envflag_file          | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vlsingle_install_download_to_control   | Whether use control or remote host to download archive                                                                               | `false`                                                                                                                                                                                           |
| vm_proxy_http                          | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |
| vm_proxy_https                         | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |

## Deprecated aliases

The `victorialogs_*` variable names are deprecated in favor of the unified `vlsingle_*` prefix and will be removed in a future release. Old names still work (each is used as a fallback when the corresponding new name is unset), and the role emits a deprecation warning when it detects one. Migrate to the new names:

| Deprecated                               | Use instead                          |
|------------------------------------------|--------------------------------------|
| victorialogs_repo_url                    | vlsingle_repo_url                    |
| victorialogs_version                     | vlsingle_version                     |
| victorialogs_enterprise                  | vlsingle_enterprise                  |
| victorialogs_license_key                 | vlsingle_license_key                 |
| victorialogs_license_key_file            | vlsingle_license_key_file            |
| victorialogs_platform                    | vlsingle_platform                    |
| victorialogs_download_url                | vlsingle_download_url                |
| victorialogs_system_user                 | vlsingle_system_user                 |
| victorialogs_system_group                | vlsingle_system_group                |
| victorialogs_data_dir                    | vlsingle_data_dir                    |
| victorialogs_retention_period_months     | vlsingle_retention_period            |
| victorialogs_service_envflag_enabled     | vlsingle_service_envflag_enabled     |
| victorialogs_service_envflag_data        | vlsingle_service_envflag_data        |
| victorialogs_service_envflag_file        | vlsingle_service_envflag_file        |
| victorialogs_install_download_to_control | vlsingle_install_download_to_control |
| victorialogs_service_args                | vlsingle_service_args                |
| victorialogs_max_open_files              | vlsingle_max_open_files              |

## Flag naming and environment variables

`vlsingle_service_args` keys are passed directly as command-line flags:

```yaml
vlsingle_service_args:
  storageDataPath: "/var/lib/victoria-logs/"
  "retention.maxDiskSpaceUsageBytes": "10GB"  # passed as -retention.maxDiskSpaceUsageBytes
```

When `vlsingle_service_envflag_enabled` is set to `true`, the `vlsingle_service_envflag_data` entries are passed as environment variables. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vlsingle_service_envflag_enabled: "true"
vlsingle_service_envflag_data:
  - "retention_maxDiskSpaceUsageBytes=10GB"  # corresponds to -retention.maxDiskSpaceUsageBytes flag
```
