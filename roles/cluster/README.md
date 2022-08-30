# VictoriaMetrics cluster role

Installs and configures VictoriaMetrics cluster running in docker.

Containers are managed as systemd units.

## Requirements
- Docker

## Example Playbook
```
---
- hosts: victoria_cluster
  collections:
    - victoriametrics.cluster
  become: true
  roles:
    - victoriametrics.cluster.docker  # replace this with a role that installs Docker in your environment
    - victoriametrics.cluster.cluster
```

## Parameters

The following table lists the configurable parameters of the playbook and their default values.

> Important - `vmstorage_group` parameter should refer name of group in ansible inventory. 
> If this parameter is not set correctly you'll see error like the following
> `AnsibleUndefinedVariable: 'dict object' has no attribute 'victoria_cluster'`

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
| `vmselect_params`                                         | VM select params passed to vm binary                                                                                                              | type: list. see `defaults/main.yml`                                 |
| `vm_docker_image_tag`                                     | Default docker tag for all images                                                                                                                 | `latest`                                                     |
| `vm_conf_host_path`                                       | Host path to configuration files                                                                                                                  | `/etc/victoriametrics`                                       |
| `environment_file_path`                                   | Path to directory with environment file for systemd EnvironmentFile directive                                                                     | `/etc/default/vm_environment`                                |
| `use_environment`                                         | Variable that controls whether pass parameters to vm binary, or to create environment file. or both of them. possible values: true, false, both.  | `false`                                                      |
| `exec_stop`                                               | Systemd additional ExecStop directive                                                                                                             | `nil`                                                        |
| `exec_start_post`                                         | Systemd additional ExecStartStop directive                                                                                                        | `nil`                                                        |
| `systemd_environment_file`                                | Systemd additional EnvironmentFile directive                                                                                                      | `nil`                                                        |
| `if_name`                                                 | Interface name to gather ip addresses of storage nodes                                                                                            | defaults to first interface                                  |
