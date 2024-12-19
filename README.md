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

- [vmsingle](./roles/vmsingle) - installs and configures VictoriaMetrics single node
- [vmagent](./roles/vmagent) - installs and configures [`vmagent`](https://docs.victoriametrics.com/vmagent/)
- [vmalert](./roles/vmalert) - installs and configures [`vmalert`](https://docs.victoriametrics.com/vmalert/)
- [vmselect](./roles/vmselect) - installs and configures [`vmselect`](https://docs.victoriametrics.com/cluster-victoriametrics/)
- [vmstorage](./roles/vmstorage) - installs and configures [`vmstorage`](https://docs.victoriametrics.com/cluster-victoriametrics/)
- [vminsert](./roles/vminsert) - installs and configures [`vminsert`](https://docs.victoriametrics.com/cluster-victoriametrics/)
- [vmauth](./roles/vmauth) - installs and configures [`vmauth`](https://docs.victoriametrics.com/vmauth/)

See [cluster](playbooks/cluster.yml) and [vmsingle](playbooks/vmsingle.yml) playbooks for examples of how to use these
roles.

## Cluster deployment

Cluster deployment example is available in [playbooks/cluster.yml](./playbooks/cluster.yml).
The playbook deploys [VictoriaMetrics cluster](https://docs.victoriametrics.com/cluster-victoriametrics/) and [vmauth](https://docs.victoriametrics.com/vmauth/) to [act as a load balancer](https://docs.victoriametrics.com/vmauth/#load-balancer-for-victoriametrics-cluster) and authentication proxy.
See [inventory](./inventory_example/cluster-inventory) for example of inventory file.

Here is a diagram of the cluster deployment:
![vm-cluster.png](vm-cluster.png)

It's also possible to use molecule scenario to create a local cluster for testing.
See [molecule](./playbooks/molecule/cluster) directory for details. The scenario uses docker as a driver and
sets up a container for each component. The scenario can be deployed by
using `make molecule-converge-cluster-integration` command.

# Development

In order to set up development environment, you need to have `docker`, `python` and `make` installed.
Run `make init-venv` to create virtual environment and install required packages for linting and testing
with [molecule](https://ansible.readthedocs.io/projects/molecule).

Please, note that [cluster](./roles/cluster) role is tested with `vagrant` and `libvirt` provider and
requires `vagrant` [to be installed](https://www.vagrantup.com/downloads).

Refer to [Makefile](./Makefile) for available commands for linting and molecule testing.
