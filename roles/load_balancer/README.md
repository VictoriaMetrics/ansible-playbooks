# LoadBalancer role

Configures load balancing between `vmselect` and `vminsert` instances.

Hosts are discovered from ansible inventory groups, naming configured by the following vars `vminsert_group` and `vmselect_group`

*Deprecation notice*: this role is deprecated in favor vmauth. It is still available in the collection, but will be removed in future releases.

## Parameters

The following table lists the configurable parameters of the playbook and their default values.

| Parameter        | Description                                                                                       | Default                                        |
|------------------|---------------------------------------------------------------------------------------------------|------------------------------------------------|
| `vmselect_group` | group of servers with victoria select select role. Used to collect ip addresses for load-balancer | `victoria_storage`                             |
| `vminsert_group` | group of servers with victoria select insert role. Used to collect ip addresses for load-balancer | `victoria_storage`                             |
| `if_name`        | # interface to gather ip address                                                                  | `{{ vars['ansible_default_ipv4'].interface }}` |
