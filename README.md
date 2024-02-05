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

# Testing

I'm using vagrant and libvirt for testing purpose. visit vendors' web-site for instructions of installing program.
vagrant: https://www.vagrantup.com/downloads

Also, most roles are tested with `molecule`. Please, check out installation docs: https://ansible.readthedocs.io/projects/molecule/installation/
