# ansible-playbooks
Ansible Playbooks for Victoria Metrics monorepo

# Parameters

The following table lists the configurable parameters of the playbook and their default values.

| Parameter                                                 | Description                                                                                                                                       | Default                                                      |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `vmstorage_group`                                         | Group of servers with victoria metrics storage role.                                                                                              | `victoria_storage`                                           |
| `vmstorage_host_path`                                     | Host path to database                                                                                                                             | `/var/lib/victoriametrics`                                   |
| `vmstorage_docker_version`                                | VM storage docker tag override. By default `vm_docker_image_tag` is used                                                                          | `nil`                                                        |
| `vmstorage_exec_stop`                                     | VM storage systemd ExecStop override. By default `exec_stop` is used                                                                              | `nil`                                                        |
| `vmstorage_exec_start_post`                               | VM storage systemd ExecStartStop override. By default `exec_start_post` is used                                                                   | `nil`                                                        |
| `vmstorage_params`                                        | VM storage params passed to vm binary                                                                                                             | type: list. see defaults.yml                                 |
| `vminsert_docker_version`                                 | VM insert docker tag override. By default `vm_docker_image_tag` is used                                                                           | `nil`                                                        |
| `vminsert_exec_stop`                                      | VM insert systemd ExecStop override. By default `exec_start_post` is used                                                                         | `nil`                                                        |
| `vminsert_exec_start_post`                                | VM insert systemd ExecStartStop override. By default `exec_start_post` is used                                                                    | `nil`                                                        |
| `vminsert_params`                                         | VM insert params passed to vm binary                                                                                                              | type: list. see defaults.yml                                 |
| `vmselect_docker_version`                                 | VM select docker tag override. By default `vm_docker_image_tag` is used                                                                           | `nil`                                                        |
| `vmselect_exec_stop`                                      | VM select systemd ExecStop override. By default `exec_start_post` is used                                                                         | `nil`                                                        |
| `vmselect_exec_start_post`                                | VM select systemd ExecStartStop override. By default `exec_start_post` is used                                                                    | `nil`                                                        |
| `vmselect_params`                                         | VM select params passed to vm binary                                                                                                              | type: list. see defaults.yml                                 |
| `vm_docker_image_tag`                                     | Default docker tag for all images                                                                                                                 | `latest`                                                     |
| `vm_conf_host_path`                                       | Host path to configuration files                                                                                                                  | `/etc/victoriametrics`                                       |
| `environment_file_path`                                   | Path to directory with environment file for systemd EnvironmentFile directive                                                                     | `/etc/default/vm_environment`                                |
| `use_environment`                                         | Variable that controls whether pass parameters to vm binary, or to create environment file. or both of them. possible values: true, false, both.  | `false`                                                      |
| `exec_stop`                                               | Systemd additional ExecStop directive                                                                                                             | `nil`                                                        |
| `exec_start_post`                                         | Systemd additional ExecStartStop directive                                                                                                        | `nil`                                                        |
| `systemd_environment_file`                                | Systemd additional EnvironmentFile directive                                                                                                      | `nil`                                                        |
| `if_name`                                                 | Interface name to gather ip addresses of storage nodes                                                                                            | defaults to first interface                                  |

# TODO
- add non-docker environment
- add vmalert role
- fix storageNode param (Done)
- fix hardcoded ports

# Testing

i'm using vagrant and virtualbox for testing purpose.
visit vendors' web-site for instructions of installing program.
vagrant: https://www.vagrantup.com/downloads
virtualbox: https://www.virtualbox.org/wiki/Downloads

install them and issue the command inside repo:
```bash
vagrant up
```