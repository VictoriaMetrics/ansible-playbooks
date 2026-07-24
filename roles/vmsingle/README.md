# VM single

Installs VictoriaMetrics single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                                   | Description                                                                                                                         | Default                                                                                                                                       |
|---------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| vmsingle_repo_url                           | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                                                          |
| vmsingle_version                            | Version to install                                                                                                                  | `v1.148.0`                                                                                                                                    |
| vmsingle_enterprise                         | Whether to use enterprise version of binaries.                                                                                      | `false`                                                                                                                                       |
| vmsingle_license_key                        | License key for VictoriaMetrics enterprise.                                                                                         | `""`                                                                                                                                          |
| vmsingle_license_key_file                   | License key file for VictoriaMetrics enterprise.                                                                                    | `""`                                                                                                                                          |
| vmsingle_download_url                       | Resulting download url.                                                                                                             | `"{{ vmsingle_repo_url }}/releases/download/{{ vmsingle_version }}/victoria-metrics{{ vmsingle_platform }}-{{ go_arch }}-{{ vmsingle_version }}{{ '-enterprise' if vmsingle_enterprise else '' }}.tar.gz"` |
| vmsingle_utils_download_url                 | Resulting download url.                                                                                                             | `"{{ vmsingle_repo_url }}/releases/download/{{ vmsingle_version }}/vmutils{{ vmsingle_platform }}-{{ go_arch }}-{{ vmsingle_version }}.tar.gz"` |
| vmsingle_system_user                        | User to run service.                                                                                                                | `victoriametrics`                                                                                                                             |
| vmsingle_system_group                       | Group to run service.                                                                                                               | `{{ vmsingle_system_user }}`                                                                                                                  |
| vmsingle_data_dir                           | Directory to store data configs.                                                                                                    | `/var/lib/victoria-metrics/`                                                                                                                  |
| vmsingle_self_scrape_interval               | Scrape interval for VictoriaMetrics self-monitoring (`-selfScrapeInterval`).                                                       | `30s`                                                                                                                                        |
| vmsingle_retention_period                   | Data retention period, passed verbatim to VictoriaMetrics as `-retentionPeriod`. With no unit suffix the value is counted in months; see the [retention docs](https://docs.victoriametrics.com/#retention) for the supported unit suffixes. | `12`                                                                                                                                        |
| vmsingle_search_max_unique_timeseries       | Max unique time series a single query may process (`-search.maxUniqueTimeseries`).                                                 | `900000`                                                                                                                                    |
| vmsingle_max_open_files                     | Open files limit for the service (systemd `LimitNOFILE`).                                                                          | `2097152`                                                                                                                                   |
| vmsingle_backup_enabled                     | Enable usage of `vmbackup` to backup to S3 .                                                                                        | `false`                                                                                                                                       |
| vmsingle_backup_destination                 | S3 backups destination.                                                                                                             | `s3://`                                                                                                                                       |
| vmsingle_backup_cron_minute                 | Backups schedule cron minute.                                                                                                       | `0`                                                                                                                                           |
| vmsingle_backup_cron_hour                   | Backups schedule cron hour.                                                                                                         | `*/2`                                                                                                                                         |
| vmsingle_backup_cron_day                    | Backups schedule cron day.                                                                                                          | `*`                                                                                                                                           |
| vmsingle_backup_cron_weekday                | Backups schedule cron weekday.                                                                                                      | `*`                                                                                                                                           |
| vmsingle_backup_cron_month                  | Backups schedule cron month.                                                                                                        | `*`                                                                                                                                           |
| vmsingle_backup_access_key                  | S3 access key.                                                                                                                      | ``                                                                                                                                            |
| vmsingle_backup_secret_key                  | S3 secret key.                                                                                                                      | ``                                                                                                                                            |
| vmsingle_backup_custom_s3_endpoint          | Custom S3 endpoint(useful for S3-compatible services).                                                                              | ``                                                                                                                                            |
| vmsingle_backup_region                      | Region for AWS configuration.                                                                                                       | `eu-west-1`                                                                                                                                   |
| vmsingle_backup_proxy_enable                | Use `http_proxy`/`https_proxy` env vars for the `vmbackup` cron job.                                                               | `false`                                                                                                                                     |
| vmsingle_service_args                       | Passes options defined above to VictoriaMetrics single.                                                                             | see [defaults.yml](./defaults/main.yml)                                                                                                       |
| vmsingle_service_envflag_enabled            | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                       |
| vmsingle_service_envflag_data               | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                       |
| vmsingle_service_envflag_file               | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                       |
| vmsingle_install_download_to_control        | Whether use control or remote host to download archive                                                                              | `false`                                                                                                                                        |
| vm_proxy_http                               | Sets environment for downloading archive                                                                                            | `""`                                                                                                                                          |
| vm_proxy_https                              | Sets environment for downloading archive                                                                                            | `""`                                                                                                                                          |

## Deprecated aliases

The `victoriametrics_*` variable names are deprecated in favor of the unified `vmsingle_*` prefix and will be removed in a future release. Old names still work (each is used as a fallback when the corresponding new name is unset), and the role emits a deprecation warning when it detects one. Migrate to the new names:

| Deprecated                                   | Use instead                            |
|----------------------------------------------|----------------------------------------|
| victoriametrics_repo_url                     | vmsingle_repo_url                      |
| victoriametrics_version                      | vmsingle_version                       |
| victoriametrics_enterprise                   | vmsingle_enterprise                    |
| victoriametrics_license_key                  | vmsingle_license_key                   |
| victoriametrics_license_key_file             | vmsingle_license_key_file              |
| victoriametrics_platform                     | vmsingle_platform                      |
| victoriametrics_download_url                 | vmsingle_download_url                  |
| victoriametrics_utils_download_url           | vmsingle_utils_download_url            |
| victoriametrics_system_user                  | vmsingle_system_user                   |
| victoriametrics_system_group                 | vmsingle_system_group                  |
| victoriametrics_data_dir                     | vmsingle_data_dir                      |
| victoriametrics_self_scrape_interval         | vmsingle_self_scrape_interval          |
| victoriametrics_retention_period_months      | vmsingle_retention_period              |
| victoriametrics_search_max_unique_timeseries | vmsingle_search_max_unique_timeseries  |
| victoriametrics_max_open_files               | vmsingle_max_open_files                |
| victoriametrics_backup_enabled               | vmsingle_backup_enabled                |
| victoriametrics_backup_destination           | vmsingle_backup_destination            |
| victoriametrics_backup_cron_minute           | vmsingle_backup_cron_minute            |
| victoriametrics_backup_cron_hour             | vmsingle_backup_cron_hour              |
| victoriametrics_backup_cron_day              | vmsingle_backup_cron_day               |
| victoriametrics_backup_cron_weekday          | vmsingle_backup_cron_weekday           |
| victoriametrics_backup_cron_month            | vmsingle_backup_cron_month             |
| victoriametrics_backup_access_key            | vmsingle_backup_access_key             |
| victoriametrics_backup_secret_key            | vmsingle_backup_secret_key             |
| victoriametrics_backup_custom_s3_endpoint    | vmsingle_backup_custom_s3_endpoint     |
| victoriametrics_backup_region                | vmsingle_backup_region                 |
| victoriametrics_backup_proxy_enable          | vmsingle_backup_proxy_enable           |
| victoriametrics_service_args                 | vmsingle_service_args                  |
| victoriametrics_service_envflag_enabled      | vmsingle_service_envflag_enabled       |
| victoriametrics_service_envflag_data         | vmsingle_service_envflag_data          |
| victoriametrics_service_envflag_file         | vmsingle_service_envflag_file          |
| victoriametrics_install_download_to_control  | vmsingle_install_download_to_control   |

## Flag naming and environment variables

`vmsingle_service_args` keys are passed directly as command-line flags:

```yaml
vmsingle_service_args:
  storageDataPath: "/var/lib/victoria-metrics/"
  retentionPeriod: "12"
  "search.maxUniqueTimeseries": "900000"  # passed as -search.maxUniqueTimeseries
```

When `vmsingle_service_envflag_enabled` is set to `true`, the `vmsingle_service_envflag_data` entries are passed as environment variables. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vmsingle_service_envflag_enabled: "true"
vmsingle_service_envflag_data:
  - "search_maxUniqueTimeseries=900000"  # corresponds to -search.maxUniqueTimeseries flag
```
