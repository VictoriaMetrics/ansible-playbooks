# VMagent

Role to install and configure vmagent. Installs by using binary from Github releases.

## Parameters

The following table lists the configurable parameters of the roles and their default values.

> Note that default `vmagent_remote_write_host` is using port for VMSingle installation. For cluster mode installed
> by using roles from this repository it is needed to point at VMSelect component which will be placed behind a load balancer.
> See [playbooks/cluster.yaml](../../playbooks/cluster.yml) for cluster deployment example.

| Parameter                           | Description                                                                                                                | Default                                                                                               |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| vmagent_repo_url                    | Repository to use for download.                                                                                            | `https://github.com/VictoriaMetrics/VictoriaMetrics`                                                  |
| vmagent_version                     | vmagent version                                                                                                            | `v1.156.0`                                                                                            |
| vmagent_enterprise                  | Whether to use enterprise version of binaries.                                                                             | `false`                                                                                               |
| vmagent_license_key                 | License key for VictoriaMetrics enterprise.                                                                                | `""`                                                                                                  |
| vmagent_license_key_file            | License key file for VictoriaMetrics enterprise.                                                                           | `""`                                                                                                  |
| vmagent_service_name                | Name of the installed system service                                                                                       | `vic-vmagent`                                                                                         |
| vmagent_download_url                | URL to download archive                                                                                                    | `{{ vmagent_repo_url }}/releases/download/{{ vmagent_version }}/vmutils{{ vmagent_platform }}-{{ go_arch }}-{{ vmagent_version }}.tar.gz` |
| vmagent_system_user                 | User to run vmagent                                                                                                        | `vic_vm_agent`                                                                                        |
| vmagent_system_group                | Group for user of vmagent                                                                                                  | `{{ vmagent_system_user }}`                                                                           |
| vmagent_bin_dir                      | Location for binary file                                                                                                   | `/usr/local/bin`                                                                                      |
| vmagent_config_dir                  | Path where configuration will be stored.                                                                                   | `/opt/vic-vmagent`                                                                                    |
| vmagent_sd_config_dir               | Path to directory to configure file_sd.                                                                                    | `{{ vmagent_config_dir }}/file_sd_configs`                                                            |
| vmagent_remote_write_host           | Remote write host URL.                                                                                                     | `http://localhost:8428`                                                                               |
| vmagent_tmp_data_path               | Path for buffering data before it is sent to remote storage (`remoteWrite.tmpDataPath`).                                   | `/tmp/vmagent`                                                                                        |
| vmagent_service_args                | Dict representing set of arguments for vmagent                                                                             | See [defaults](defaults/main.yml)                                                                     |
| vmagent_scrape_config               | Prometheus scrape configuration                                                                                            | See [defaults](defaults/main.yml)                                                                     |
| vmagent_scrape_config_files_dir     | Local dir with extra scrape config files. Copied to `configs/` and loaded via `scrape_config_files`.                       | `""`                                                                                                  |
| vmagent_scrape_config_prune_stale   | Remove files from the target `configs/` dir which no longer exist in the local dir.                                        | `false`                                                                                               |
| vmagent_aggregation_config          | Stream aggregation configuration                                                                                           | []                                                                                                    |
| vmagent_install_download_to_control | Whether use control or remote host to download installation archive                                                        | false                                                                                                  |
| vmagent_exec_start_post             | Post start hook for systemd unit.                                                                                         | `""`                                                                                                  |
| vmagent_exec_stop                   | Stop command for systemd unit.                                                                                            | `""`                                                                                                  |
| vmagent_systemd_protect_home        | Configure Systemd home protection. See See https://www.freedesktop.org/software/systemd/man/systemd.exec.html#ProtectHome= | `"yes"`                                                                                               |
| vm_proxy_http                       | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |
| vm_proxy_https                      | Sets environment for downloading archive                                                                                   | `""`                                                                                                  |

## Flag naming

`vmagent_service_args` keys are passed directly as command-line flags:

```yaml
vmagent_service_args:
  promscrape.config: "/opt/vic-vmagent/scrape.yml"
  remoteWrite.url: "http://localhost:8428/api/v1/write"
  remoteWrite.tmpDataPath: "/var/lib/vmagent-remotewrite-data"
```

## Loading scrape configs from multiple files

`vmagent` supports loading scrape configs from multiple files via the `scrape_config_files` section of the promscrape config.
See [the vmagent docs](https://docs.victoriametrics.com/victoriametrics/vmagent/#loading-scrape-configs-from-multiple-files) for details.

Set `vmagent_scrape_config_files_dir` to an absolute path to a local directory on the control node:

```yaml
vmagent_scrape_config_files_dir: "{{ playbook_dir }}/files/vmagent_scrape_configs"
```

If this directory exists, the role copies its top-level `*.yml` and `*.yaml` files to
`{{ vmagent_config_dir }}/configs` and adds the following section to the promscrape config:

```yaml
scrape_config_files:
- "{{ vmagent_config_dir }}/configs/*.yml"
- "{{ vmagent_config_dir }}/configs/*.yaml"
```

Set `vmagent_scrape_config_prune_stale` to `true` to also remove files from `configs/` which no longer exist
in the local directory. Note that this removes all stale `*.yml` and `*.yaml` files from that directory,
including ones added manually.

Do not define `scrape_config_files` inside `vmagent_scrape_config` when this feature is enabled: the role
owns that section and would render a duplicate key.

Each file in that directory must contain a list of scrape configs, without the top-level `scrape_configs` key:

```yaml
- job_name: foo
  static_configs:
  - targets: ["vmagent:8429"]
```

Changes to the copied files are validated with `vmagent -dryRun` and restart `vmagent` so that they are applied.
