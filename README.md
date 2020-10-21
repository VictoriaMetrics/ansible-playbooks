# ansible-playbooks
Ansible Playbooks for Victoria Metrics monorepo

# Parameters

The following table lists the configurable parameters of the playbook and their default values.

| Parameter                           | Description                                                                            | Default                      |
|-------------------------------------|----------------------------------------------------------------------------------------|------------------------------|
| `vmstorage_group`                   | Group of servers with victoria metrics storage role.                                   | `victoria_storage`           |
| `vmstorage_host_path`               | Host path to database                                                                  | `/var/lib/victoriametrics`   |
| `vmstorage_docker_version`          | VM storage docker tag override. By default `vm_docker_image_tag` is used               | `nil`                        |
| `vmstorage_environment_file`        | VM storage systemd EnvironmentFile override. By default `environment_file` is used     | `nil`                        |
| `vmstorage_exec_stop`               | VM storage systemd ExecStop override. By default `exec_stop` is used                   | `nil`                        |
| `vmstorage_exec_start_post`         | VM storage systemd ExecStartStop override. By default `exec_start_post` is used        | `nil`                        |
| `vminsert_docker_version`           | VM insert docker tag override. By default `vm_docker_image_tag` is used                | `nil`                        |
| `vminsert_replication_factor`       | VM insert replication factor                                                           | `1`                          |
| `vminsert_environment_file`         | VM insert systemd EnvironmentFile override. By default `environment_file` is used      | `nil`                        |
| `vminsert_exec_stop`                | VM insert systemd ExecStop override. By default `exec_start_post` is used              | `nil`                        |
| `vminsert_exec_start_post`          | VM insert systemd ExecStartStop override. By default `exec_start_post` is used         | `nil`                        |
| `vmselect_docker_version`           | VM select docker tag override. By default `vm_docker_image_tag` is used                | `nil`                        |
| `vmselect_environment_file`         | VM select systemd EnvironmentFile override. By default `environment_file` is used      | `nil`                        |
| `vmselect_min_scrape_interval`      | VM select dedup.minScrapeInterval parameter in ms                                      | `1`                          |
| `vmselect_exec_stop`                | VM select systemd ExecStop override. By default `exec_start_post` is used              | `nil`                        |
| `vmselect_exec_start_post`          | VM select systemd ExecStartStop override. By default `exec_start_post` is used         | `nil`                        |
| `vm_docker_image_tag`               | Default docker tag for all images                                                      | `latest`                     |
| `vm_conf_host_path`                 | Host path to configuration files                                                       | `/etc/victoriametrics`       |
| `environment_file`                  | Systemd EnvironmentFile directive                                                      | `nil`                        |
| `exec_stop`                         | Systemd additional ExecStop directive                                                  | `nil`                        |
| `exec_start_post`                   | Systemd additional ExecStartStop directive                                             | `nil`                        |

# TODO
- add non-docker environment
- add vmalert role
- add almost all vm variables to playbook