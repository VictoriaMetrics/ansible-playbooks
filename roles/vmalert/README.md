# VMalert

Installs `vmalert` as binary running with systemd

## Parameters

> Note that default `vic_vm_alert_datasource_url` is using port for VMSingle installation. For cluster mode installed by [role](../cluster) with [loadbalancer](../load_balancer) from this repository it is needed to point at VMSelect component which will be `load_balancer:8481`.

| Parameter                        | Description                                                 | Default                                                                                                                              |
|----------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| vic_vm_alert_repo_url            | Repository to get binaries                                  | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                                                 |
| vic_vm_alert_version             | Version to install                                          | `v1.95.0`                                                                                                                            |
| vic_vm_alert_download_url        | Resulting download url.                                     | `"{{ vic_vm_alert_repo_url }}/releases/download/{{ vic_vm_alert_version }}/vmutils-{{ go_arch }}-{{ vic_vm_alert_version }}.tar.gz"` |
| vic_vm_alert_system_user         | User to run `vmalert`.                                      | `vic_vm_alert`                                                                                                                       |
| vic_vm_alert_system_group        | Group to run `vmalert`.                                     | `{{ vic_vm_alert_system_user }}`                                                                                                     |
| vic_vm_alert_config_dir          | Directory to place configs.                                 | `/opt/vic-vmalert`                                                                                                                   |
| vic_vm_alert_rules_config_path   | Location to place rules.                                    | `/opt/vic-vmalert/rules.yml`                                                                                                         |
| vic_vm_alert_alertmanager_url    | Url of alertmanager.                                        | `http://localhost:9093`                                                                                                              |
| vic_vm_alert_datasource_url      | Url of datasource(e.g. VictoriaMetrics single or vmselect). | `http://localhost:8428`                                                                                                              |
| vic_vm_alert_evaluation_interval | Rules evaluation interval.                                  | `30s`                                                                                                                                |
| vic_vm_alert_max_open_files      | Limit for number of opened files.                           | `2097152`                                                                                                                            |
| vic_vm_alert_service_args        | Passes options defined above to `vmalert`.                  | see [defaults.yml](./defaults/main.yml)                                                                                              |
| vic_vm_alert_service_args        | Passes options defined above to `vmalert`.                  | see [defaults.yml](./defaults/main.yml)                                                                                              |
| vic_vm_alert_rules               | Rules                                                       | see [defaults.yml](./defaults/main.yml)                                                                                              |
