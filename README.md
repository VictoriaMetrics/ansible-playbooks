# ansible-playbooks

Ansible roles and playbooks for Victoria Metrics.

## How to install

Roles are published in ansible galaxy: https://galaxy.ansible.com/ui/namespaces/victoriametrics/

Install collection:

```shell
ansible-galaxy collection install victoriametrics.cluster
```

## Contents

Collection includes the following roles:

- [docker](./roles/docker) - role for docker installation
- [load_balancer](./roles/load_balancer) - nginx setup for load balancing between select and insert nodes
- [cluster](./roles/cluster) - installs and configures VictoriaMetrics cluster running in docker
- [single](./roles/single) - installs and configures VictoriaMetrics single node
- [vmagent](./roles/vmagent) - installs and configures `vmagent`
- [vmalert](./roles/vmalert) - installs and configures `vmalert`

# TODO
- add non-docker environment
- fix hardcoded ports

# Development

In order to set up development environment, you need to have `docker`, `python` and `make` installed.
Run `make init-venv` to create virtual environment and install required packages for linting and testing with [molecule](https://ansible.readthedocs.io/projects/molecule).

Please, note that [cluster](./roles/cluster) role is tested with `vagrant` and `libvirt` provider and requires `vagrant` [to be installed](https://www.vagrantup.com/downloads).

Refer to [Makefile](./Makefile) for available commands for linting and molecule testing.
