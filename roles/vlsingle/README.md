# VL single

Installs VictoriaLogs single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                              | Description                                                                                                                         | Default                                                                                                                                                                                          |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| victorialogs_repo_url                  | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                                                                                                             |
| victorialogs_version                   | Version to install                                                                                                                  | `v1.3.2`                                                                                                                                                                                         |
| victorialogs_download_url              | Resulting download url.                                                                                                             | `"{{ victorialogs_repo_url }}/releases/download/{{ victorialogs_version }}-victorialogs/victoria-logs-{{ victorialogs_platform }}-{{ go_arch }}-{{ victorialogs_version }}-victorialogs.tar.gz"` |
| victorialogs_system_user               | User to run service.                                                                                                                | `victoriametrics`                                                                                                                                                                                |
| victorialogs_system_group              | Group to run service.                                                                                                               | `{{ victorialogs_system_user }}`                                                                                                                                                                 |
| victorialogs_data_dir                  | Directory to store data configs.                                                                                                    | `/var/lib/victoria-logs/`                                                                                                                                                                        |
| victorialogs_service_args              | Passes options defined above to VictoriaLogs single.                                                                                | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victorialogs_service_envflag_enabled   | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                                                                          |
| victorialogs_service_envflag_data      | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victorialogs_service_envflag_file      | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |