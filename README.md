# ansible-playbooks
Ansible roles and playbooks for Victoria Metrics.

## How to install

Roles are published in ansible galaxy: https://galaxy.ansible.com/victoriametrics

Install collection:
```shell
ansible-galaxy collection install victoriametrics.cluster
```

## Contents

Collection includes the following roles:
- [docker](./roles/docker) - role for docker installation
- [load_balancer](./roles/load_balancer) - nginx setup for load balancing between select and insert nodes
- [victoria_cluster](./roles/victoria_cluster) - installs and configures VictoriaMetrics cluster running in docker
- [victoria_vmagent](./roles/victoria_vmagent) - installs and configures VMagent


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
