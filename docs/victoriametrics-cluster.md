# VictoriaMetrics Cluster Deployment

Cluster deployment example is available in [playbooks/cluster.yml](../playbooks/cluster.yml).
The playbook deploys [VictoriaMetrics cluster](https://docs.victoriametrics.com/cluster-victoriametrics/) and [vmauth](https://docs.victoriametrics.com/vmauth/) to [act as a load balancer](https://docs.victoriametrics.com/vmauth/#load-balancer-for-victoriametrics-cluster) and authentication proxy.
See [inventory](../inventory_example/cluster-inventory) for example of inventory file.

Here is a diagram of the cluster deployment:

```mermaid
graph TD
    Write[Write traffic] --> vmauth-write[vmauth]

    vmauth-write -- /insert/* --> vminsert-1
    vmauth-write -- /insert/* --> vminsert-N

    subgraph vminsert group
        vminsert-1
        vminsert-N
    end

    vminsert-1 --> vmstorage-1
    vminsert-1 --> vmstorage-N
    vminsert-N --> vmstorage-1
    vminsert-N --> vmstorage-N

    subgraph vmstorage group
        vmstorage-1
        vmstorage-N
    end

    vmstorage-1 --> vmselect-1
    vmstorage-1 --> vmselect-N
    vmstorage-N --> vmselect-1
    vmstorage-N --> vmselect-N

    subgraph vmselect group
        vmselect-1
        vmselect-N
    end

    vmselect-1 -- /select/* --> vmauth-read[vmauth]
    vmselect-N -- /select/* --> vmauth-read

    vmauth-read --> Grafana
    vmauth-read --> vmalert

    subgraph Read traffic
        Grafana
        vmalert
    end
```

It's also possible to use molecule scenario to create a local cluster for testing.
See [molecule](../playbooks/molecule/cluster) directory for details. The scenario uses docker as a driver and
sets up a container for each component. The scenario can be deployed by
using `make molecule-converge-cluster-integration` command.
