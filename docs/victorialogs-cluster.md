# VictoriaLogs Cluster Deployment

Cluster deployment example is available in [playbooks/vlcluster.yml](../playbooks/vlcluster.yml).
The playbook deploys [VictoriaLogs cluster](https://docs.victoriametrics.com/victorialogs/cluster/) and [vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/) to act as a load balancer.
See [inventory](../inventory_example/vlcluster-inventory) for example of inventory file.

All three cluster components (vlstorage, vlinsert, vlselect) use the same `vlsingle` role since they share a single binary. The component role is determined by flags passed via `victorialogs_service_args`:

- **vlstorage** — uses role defaults (no extra flags needed)
- **vlinsert** — sets `storageNode` and `select.disable: "true"`
- **vlselect** — sets `storageNode` and `insert.disable: "true"`

Here is a diagram of the cluster deployment:

```mermaid
graph TD
    Write[Write traffic] --> vmauth-write[vmauth]

    vmauth-write -- /insert/* --> vlinsert-1
    vmauth-write -- /insert/* --> vlinsert-N

    subgraph vlinsert group
        vlinsert-1
        vlinsert-N
    end

    vlinsert-1 --> vlstorage-1
    vlinsert-1 --> vlstorage-N
    vlinsert-N --> vlstorage-1
    vlinsert-N --> vlstorage-N

    subgraph vlstorage group
        vlstorage-1
        vlstorage-N
    end

    vlstorage-1 --> vlselect-1
    vlstorage-1 --> vlselect-N
    vlstorage-N --> vlselect-1
    vlstorage-N --> vlselect-N

    subgraph vlselect group
        vlselect-1
        vlselect-N
    end

    vlselect-1 -- /select/* --> vmauth-read[vmauth]
    vlselect-N -- /select/* --> vmauth-read

    vmauth-read --> Read[Read traffic]
```

It's also possible to use molecule scenario to create a local cluster for testing.
See [molecule](../playbooks/molecule/vlcluster) directory for details. The scenario uses docker as a driver and
sets up a container for each component. The scenario can be deployed by
using `make molecule-converge-vlcluster-integration` command.
