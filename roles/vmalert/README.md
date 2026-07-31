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
| vmalert_download_url               | Resulting download url.                                     | `"{{ vmalert_repo_url }}/releases/download/{{ vmalert_version }}/vmutils{{ vmalert_platform }}-{{ go_arch }}-{{ vmalert_version }}{{ '-enterprise' if vmalert_enterprise else '' }}.tar.gz"` |
| vmalert_system_user                | User to run `vmalert`.                                      | `vic_vm_alert`                                                                                                                       |
| vmalert_system_group               | Group to run `vmalert`.                                     | `{{ vmalert_system_user }}`                                                                                                          |
| vmalert_bin_dir                    | Location for binary file.                                   | `/usr/local/bin`                                                                                                                     |
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
| vmalert_service_envflag_enabled    | Enable usage of environment variables for configuration. Read more: [docs](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) | `"false"`                                             |
| vmalert_service_envflag_data       | Flags data to pass to service                               | `[]`                                                                                                                                 |
| vmalert_service_envflag_file       | Location of env file to include for service.                | `/etc/default/{{ vmalert_service_name }}`                                                                                            |
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

`vmalert_service_args` keys are passed directly as command-line flags. A list value renders the flag once per item, which is required for flags accepting multiple values:

```yaml
vmalert_service_args:
  datasource.url: "http://localhost:8428"
  notifier.url: "http://localhost:9093"
  rule: "/opt/vic-vmalert/rules.yml"
```

## Configuration via environment variables

When `vmalert_service_envflag_enabled` is set to `true`, the role adds `-envflag.enable` to the service command line and lists two `EnvironmentFile=` entries in the unit. Each `.` in a flag name must be replaced with `_` when using environment variables. See [VictoriaMetrics documentation](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#environment-variables) for details.

```yaml
vmalert_service_envflag_enabled: "true"
vmalert_service_envflag_data:
  - "external_url=https://vmalert.example.com"  # corresponds to -external.url flag
```

Command-line flags win: the upstream `-envflag.enable` description states that "Command line flag values have priority over values from environment vars". Since the role renders every `vmalert_service_args` entry onto the command line, environment variables are only useful for flags that are not in `vmalert_service_args`.

`rule` is the exception to watch for. When `vmalert_default_rules_enabled` is `true` the role appends `-rule={{ vmalert_rules_config_path }}` to the command line even though `rule` never appears in `vmalert_service_args`, so setting `rule` through the environment is silently ignored. Set `vmalert_default_rules_enabled: false` if you want to supply it from the environment.

### The two env files

| Variable | Default | Managed by | Contents |
|---|---|---|---|
| `vmalert_service_envflag_data_file` | `/etc/default/{{ vmalert_service_name }}.env` | the role, rewritten on every run | `vmalert_service_envflag_data` |
| `vmalert_service_envflag_file` | `/etc/default/{{ vmalert_service_name }}` | you | anything you put there |

The role renders `vmalert_service_envflag_data` into the first file and lists it before the second, so a key set in your file overrides the same key coming from `vmalert_service_envflag_data`: per `systemd.exec(5)`, when the same variable is set twice "the files will be read in the order they are specified and the later setting will override the earlier setting".

Both paths follow `vmalert_service_name`, so renamed instances get their own files. Both are created at mode `0600` owned by `root:root`; systemd reads `EnvironmentFile=` as PID 1, so that does not prevent the service from picking the values up. Neither parent directory is created for you: pointing either variable at a path under a directory that does not exist fails the play with `Error, could not touch target: [Errno 2] No such file or directory`.

Put secrets in `vmalert_service_envflag_file`. It is the file the role never reads or rewrites, so a secret written there survives every subsequent run. `vmalert_service_envflag_data` is regular inventory data - it ends up in the role-managed file at `0600`, but it also lives wherever your inventory lives.

Each `vmalert_service_envflag_data` entry must be a single-line `KEY=value` string whose key matches `[A-Za-z_][A-Za-z0-9_]*` and whose value contains no `'`. The role asserts this and fails the play on any entry that does not match, reporting the 1-based positions of the offending entries rather than their contents, since values can hold secrets. Two reasons for the check:

- The role writes each entry as `KEY='value'`. systemd recognizes no escape sequences inside single quotes, so a `'` in the value terminates it early and corrupts the rest of the line. Values needing a literal `'` go in `vmalert_service_envflag_file`, where you control the quoting.
- systemd silently drops an assignment whose variable name it rejects - it logs `Ignoring invalid environment assignment` and starts the service anyway - so a `.` left in a key would never be applied and never reported as an error.

Single-quoting is also what makes values literal: `%` needs no doubling, and `\` reaches the binary as written, which is what regex-valued flags need.

Further caveats:

- Both `EnvironmentFile=` entries are rendered without systemd's `-` prefix, so the unit fails to start if either file is deleted while envflag is enabled.
- The role never reads `vmalert_service_envflag_file` back, so editing it out of band does not notify the restart handler. Restart the service yourself after changing it.
- Flipping `vmalert_service_envflag_enabled` back to `false` leaves both files on disk; the unit simply stops referencing them.

## Supplying rules from external files

By default the role renders `vmalert_rules` to `vmalert_rules_config_path` and adds a matching `-rule` flag to the service. To manage rule files outside this role (for example, copying upstream alert bundles via `pre_tasks`), set:

```yaml
vmalert_default_rules_enabled: false
vmalert_service_args:
  rule: "/opt/vic-vmalert/rules/*.yml"
  rule.configCheckInterval: "30s"
```

When `vmalert_default_rules_enabled` is `false`, the role skips both the rules template and the automatic `-rule` injection, leaving `vmalert_service_args.rule` as the sole source of truth.
