# VMalert

Installs `vmalert` as binary running with systemd

## Parameters

> Note that default `vmalert_datasource_url` is using port for VMSingle installation. For cluster mode installed
> by using roles from this repository it is needed to point at VMSelect component which will be placed behind a load balancer.
> See [playbooks/cluster.yaml](../../playbooks/cluster.yml) for cluster deployment example.

| Parameter                          | Description                                                 | Default                                                                                                                              |
|------------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| vmalert_repo_url                   | Repository to get binaries                                  | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                                                 |
| vmalert_version                    | Version to install                                          | `v1.148.0`                                                                                                                           |
| vmalert_enterprise                 | Whether to use enterprise version of binaries.              | `false`                                                                                                                              |
| vmalert_license_key                | License key for VictoriaMetrics enterprise.                 | `""`                                                                                                                                 |
| vmalert_license_key_file           | License key file for VictoriaMetrics enterprise.            | `""`                                                                                                                                 |
| vmalert_download_url               | Resulting download url.                                     | `"{{ vmalert_repo_url }}/releases/download/{{ vmalert_version }}/vmutils{{ vmalert_platform }}-{{ go_arch }}-{{ vmalert_version }}.tar.gz"` |
| vmalert_system_user                | User to run `vmalert`.                                      | `vic_vm_alert`                                                                                                                       |
| vmalert_system_group               | Group to run `vmalert`.                                     | `{{ vmalert_system_user }}`                                                                                                          |
| vmalert_config_dir                 | Directory to place configs.                                 | `/opt/vic-vmalert`                                                                                                                   |
| vmalert_default_rules_enabled      | Whether to render `vmalert_rules` to a file and auto-inject `-rule` into the service args. Set to `false` when providing rule files via other means (e.g. `pre_tasks` copying externally managed files). | `true`                                                                                                                               |
| vmalert_rules_config_path          | Location to place rules. Used only when `vmalert_default_rules_enabled` is `true`. | `/opt/vic-vmalert/rules.yml`                                                                                                         |
| vmalert_alertmanager_url           | Url of alertmanager.                                        | `http://localhost:9093`                                                                                                              |
| vmalert_datasource_url             | Url of datasource(e.g. VictoriaMetrics single or vmselect). | `http://localhost:8428`                                                                                                              |
| vmalert_evaluation_interval        | Rules evaluation interval.                                  | `30s`                                                                                                                                |
| vmalert_max_open_files             | Limit for number of opened files.                           | `2097152`                                                                                                                            |
| vmalert_service_args               | Passes options defined above to `vmalert`.                  | see [defaults.yml](./defaults/main.yml)                                                                                              |
| vmalert_rules                      | Rules                                                       | see [defaults.yml](./defaults/main.yml)                                                                                              |
| vmalert_service_name               | Service name that will be created by systemd or init        | see [defaults.yml](./defaults/main.yml)                                                                                              |
| vmalert_install_download_to_control | Whether use control or remote host to download archive     | `false`                                                                                                                              |
| vm_proxy_http                      | Sets environment for downloading archive                    | `""`                                                                                                                                |
| vm_proxy_https                     | Sets environment for downloading archive                    | `""`                                                                                                                                |

## Deprecated aliases

The `vic_vm_alert_*` variable names are deprecated in favor of the unified `vmalert_*` prefix and will be removed in a future release. Old names still work (each is used as a fallback when the corresponding new name is unset), and the role emits a deprecation warning when it detects one. Migrate to the new names:

| Deprecated                                 | Use instead                         |
|--------------------------------------------|-------------------------------------|
| vic_vm_alert_repo_url                      | vmalert_repo_url                    |
| vic_vm_alert_version                       | vmalert_version                     |
| vic_vm_alert_enterprise                    | vmalert_enterprise                  |
| vic_vm_alert_license_key                   | vmalert_license_key                 |
| vic_vm_alert_license_key_file              | vmalert_license_key_file            |
| vic_vm_alert_platform                      | vmalert_platform                    |
| vic_vm_alert_download_url                  | vmalert_download_url                |
| vic_vm_alert_system_user                   | vmalert_system_user                 |
| vic_vm_alert_system_group                  | vmalert_system_group                |
| vic_vm_alert_config_dir                    | vmalert_config_dir                  |
| vic_vm_alert_default_rules_enabled         | vmalert_default_rules_enabled       |
| vic_vm_alert_rules_config_path             | vmalert_rules_config_path           |
| vic_vm_alert_alertmanager_url              | vmalert_alertmanager_url            |
| vic_vm_alert_datasource_url                | vmalert_datasource_url              |
| vic_vm_alert_evaluation_interval           | vmalert_evaluation_interval         |
| vic_vm_alert_max_open_files                | vmalert_max_open_files              |
| vic_vm_alert_service_args                  | vmalert_service_args                |
| vic_vm_alert_rules                         | vmalert_rules                       |
| vic_vm_alert_service_name                  | vmalert_service_name                |
| vic_vm_alert_install_download_to_control   | vmalert_install_download_to_control |

## Flag naming

`vmalert_service_args` keys are passed directly as command-line flags:

```yaml
vmalert_service_args:
  datasource.url: "http://localhost:8428"
  notifier.url: "http://localhost:9093"
  rule: "/opt/vic-vmalert/rules.yml"
```

## Supplying rules from external files

By default the role renders `vmalert_rules` to `vmalert_rules_config_path` and adds a matching `-rule` flag to the service. To manage rule files outside this role (for example, copying upstream alert bundles via `pre_tasks`), set:

```yaml
vmalert_default_rules_enabled: false
vmalert_service_args:
  rule: "/opt/vic-vmalert/rules/*.yml"
  rule.configCheckInterval: "30s"
```

When `vmalert_default_rules_enabled` is `false`, the role skips both the rules template and the automatic `-rule` injection, leaving `vmalert_service_args.rule` as the sole source of truth.
