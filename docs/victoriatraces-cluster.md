# VictoriaTraces Cluster Deployment

Cluster deployment example is available in [playbooks/vtcluster.yml](../playbooks/vtcluster.yml).
The playbook deploys [VictoriaTraces cluster](https://docs.victoriametrics.com/victoriatraces/cluster/) and [vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/) to act as a load balancer.
See [inventory](../inventory_example/vtcluster-inventory) for example of inventory file.

All three cluster components (vtstorage, vtinsert, vtselect) use the same `vtsingle` role since they share a single binary. The component role is determined by flags passed via `victoriatraces_service_args`:

- **vtstorage** — uses role defaults (no extra flags needed)
- **vtinsert** — sets `storageNode` and `select.disable: "true"`
- **vtselect** — sets `storageNode` and `insert.disable: "true"`

Here is a diagram of the cluster deployment:

```mermaid
graph TD
    Write[Write traffic] --> vmauth-write[vmauth]

    vmauth-write -- /insert/* --> vtinsert-1
    vmauth-write -- /insert/* --> vtinsert-N

    subgraph vtinsert group
        vtinsert-1
        vtinsert-N
    end

    vtinsert-1 --> vtstorage-1
    vtinsert-1 --> vtstorage-N
    vtinsert-N --> vtstorage-1
    vtinsert-N --> vtstorage-N

    subgraph vtstorage group
        vtstorage-1
        vtstorage-N
    end

    vtstorage-1 --> vtselect-1
    vtstorage-1 --> vtselect-N
    vtstorage-N --> vtselect-1
    vtstorage-N --> vtselect-N

    subgraph vtselect group
        vtselect-1
        vtselect-N
    end

    vtselect-1 -- /select/* --> vmauth-read[vmauth]
    vtselect-N -- /select/* --> vmauth-read

    vmauth-read --> Read[Read traffic]
```

It's also possible to use molecule scenario to create a local cluster for testing.
See [molecule](../playbooks/molecule/vtcluster) directory for details. The scenario uses docker as a driver and
sets up a container for each component. The scenario can be deployed by
using `make molecule-converge-vtcluster-integration` command.
