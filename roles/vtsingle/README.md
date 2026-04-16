# VT single

Installs VictoriaTraces single binary running with systemd

## Parameters

See full list at [defaults.yml](./defaults/main.yml)

| Parameter                              | Description                                                                                                                         | Default                                                                                                                                                                                          |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| victoriatraces_repo_url                  | Repository to get binaries                                                                                                          | `https://github.com/VictoriaMetrics/VictoriaTraces`                                                                                                                                             |
| victoriatraces_version                   | Version to install                                                                                                                  | `v0.2.0`                                                                                                                                                                                         |
| victoriatraces_download_url              | Resulting download url.                                                                                                             | `"{{ victoriatraces_repo_url }}/releases/download/{{ victoriatraces_version }}/victoria-traces-{{ victoriatraces_platform }}-{{ go_arch }}-{{ victoriatraces_version }}.tar.gz"` |
| victoriatraces_system_user               | User to run service.                                                                                                                | `victoriatraces`                                                                                                                                                                                |
| victoriatraces_system_group              | Group to run service.                                                                                                               | `{{ victoriatraces_system_user }}`                                                                                                                                                                 |
| victoriatraces_data_dir                  | Directory to store data configs.                                                                                                    | `/var/lib/victoria-traces/`                                                                                                                                                                        |
| victoriatraces_service_args              | Passes options defined above to VictoriaTraces single.                                                                                | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victoriatraces_service_envflag_enabled   | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/#environment-variables) | `false`                                                                                                                                                                                          |
| victoriatraces_service_envflag_data      | Flags data to pass to service                                                                                                       | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victoriatraces_service_envflag_file      | Location of env file to include for service.                                                                                        | see [defaults.yml](./defaults/main.yml)                                                                                                                                                          |
| victoriatraces_install_download_to_control | Whether use control or remote host to download archive                                                                               | `true`                                                                                                                                                                                           |
| vm_proxy_http                               | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |
| vm_proxy_https                              | Sets environment for downloading archive                                                                                             | `""`                                                                                                                                                                                            |

## Flag naming and environment variables

`victoriatraces_service_args` keys are passed directly as command-line flags:

```yaml
victoriatraces_service_args:
  storageDataPath: "/var/lib/victoria-traces/"
  "http.pathPrefix": "/traces"  # passed as -http.pathPrefix
```

When `victoriatraces_service_envflag_enabled` is set to `true`, the `victoriatraces_service_envflag_data` entries are passed as environment variables. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
victoriatraces_service_envflag_enabled: "true"
victoriatraces_service_envflag_data:
  - "http_pathPrefix=/traces"  # corresponds to -http.pathPrefix flag
```
