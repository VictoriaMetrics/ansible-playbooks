# VT single

Installs VictoriaTraces single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                              | Description                                                                                                                         | Default                                                                                                                                                                                          |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| vtsingle_repo_url                      | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaTraces`                                                                                                                                             |
| vtsingle_version                       | Version to install                                                                                                                  | `v0.9.4`                                                                                                                                                                                         |
| vtsingle_download_url                  | Resulting download url.                                                                                                             | `"{{ vtsingle_repo_url }}/releases/download/{{ vtsingle_version }}/victoria-traces-{{ vtsingle_platform }}-{{ go_arch }}-{{ vtsingle_version }}.tar.gz"` |
| vtsingle_system_user                   | User to run service.                                                                                                                | `victoriatraces`                                                                                                                                                                                |
| vtsingle_system_group                  | Group to run service.                                                                                                               | `{{ vtsingle_system_user }}`                                                                                                                                                                 |
| vtsingle_data_dir                      | Directory to store data configs.                                                                                                    | `/var/lib/victoria-traces/`                                                                                                                                                                        |
| vtsingle_retention_period              | Data retention period, passed verbatim to VictoriaTraces as `-retentionPeriod`. With no unit suffix the value is counted in months; see the [retention docs](https://docs.victoriametrics.com/victoriatraces/#retention) for the supported unit suffixes. | `12`                                                                                                                                                                                            |
| vtsingle_max_open_files                | Open files limit for the service (systemd `LimitNOFILE`).                                                                          | `2097152`                                                                                                                                                                                       |
| vtsingle_service_args                  | Passes options defined above to VictoriaTraces single.                                                                                | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vtsingle_service_envflag_enabled       | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                                                                          |
| vtsingle_service_envflag_data          | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vtsingle_service_envflag_file          | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| vtsingle_install_download_to_control   | Whether use control or remote host to download archive                                                                               | `false`                                                                                                                                                                                           |
| vm_proxy_http                          | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |
| vm_proxy_https                         | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |

## Deprecated aliases

The `victoriatraces_*` variable names are deprecated in favor of the unified `vtsingle_*` prefix and will be removed in a future release. Old names still work (each is used as a fallback when the corresponding new name is unset), and the role emits a deprecation warning when it detects one. Migrate to the new names:

| Deprecated                                 | Use instead                          |
|--------------------------------------------|--------------------------------------|
| victoriatraces_repo_url                    | vtsingle_repo_url                    |
| victoriatraces_version                     | vtsingle_version                     |
| victoriatraces_platform                    | vtsingle_platform                    |
| victoriatraces_download_url                | vtsingle_download_url                |
| victoriatraces_system_user                 | vtsingle_system_user                 |
| victoriatraces_system_group                | vtsingle_system_group                |
| victoriatraces_data_dir                    | vtsingle_data_dir                    |
| victoriatraces_retention_period_months     | vtsingle_retention_period            |
| victoriatraces_service_envflag_enabled     | vtsingle_service_envflag_enabled     |
| victoriatraces_service_envflag_data        | vtsingle_service_envflag_data        |
| victoriatraces_service_envflag_file        | vtsingle_service_envflag_file        |
| victoriatraces_install_download_to_control | vtsingle_install_download_to_control |
| victoriatraces_service_args                | vtsingle_service_args                |
| victoriatraces_max_open_files              | vtsingle_max_open_files              |

## Flag naming and environment variables

`vtsingle_service_args` keys are passed directly as command-line flags:

```yaml
vtsingle_service_args:
  storageDataPath: "/var/lib/victoria-traces/"
  "http.pathPrefix": "/traces"  # passed as -http.pathPrefix
```

When `vtsingle_service_envflag_enabled` is set to `true`, the `vtsingle_service_envflag_data` entries are passed as environment variables. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vtsingle_service_envflag_enabled: "true"
vtsingle_service_envflag_data:
  - "http_pathPrefix=/traces"  # corresponds to -http.pathPrefix flag
```
