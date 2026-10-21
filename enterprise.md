# Enterprise installation

This page covers how to turn on VictoriaMetrics enterprise components, how to pass the license, and what to watch for in production.

To get a license, [request a trial](https://victoriametrics.com/products/enterprise/trial/) or [contact VictoriaMetrics](https://victoriametrics.com/products/enterprise/).

## Supported roles

| Role      | Default service user | License flag is passed via                | Add other license flags to |
|-----------|----------------------|-------------------------------------------|----------------------------|
| vmsingle  | `victoriametrics`    | command line                              | `vmsingle_service_args`    |
| vmagent   | `vic_vm_agent`       | command line                              | `vmagent_service_args`     |
| vmalert   | `vic_vm_alert`       | command line                              | `vmalert_service_args`     |
| vmauth    | `victoriametrics`    | command line                              | `vmauth_service_args`      |
| vminsert  | `victoriametrics`    | environment file (`-envflag.enable`)      | `vminsert_config`          |
| vmselect  | `victoriametrics`    | environment file (`-envflag.enable`)      | `vmselect_config`          |
| vmstorage | `victoriametrics`    | environment file (`-envflag.enable`)      | `vmstorage_config`         |
| vlsingle  | `victorialogs`       | command line                              | `vlsingle_service_args`    |
| vlagent   | `vic_vl_agent`       | command line                              | `vlagent_service_args`     |

The `vtsingle` role has no Enterprise version as VictoriaTraces does not have one.

## Enable Enterprise

Every supported role takes the same three variables, prefixed with the role name:

| Variable                  | Description                                                   | Default |
|---------------------------|---------------------------------------------------------------|---------|
| `<role>_enterprise`       | Download the `-enterprise` release archive instead of the open-source one. | `false` |
| `<role>_license_key`      | License key, passed as `-license`.                            | `""`    |
| `<role>_license_key_file` | Path to the license file on the target host, passed as `-licenseFile`. | `""`    |

When `<role>_enterprise` is `true`, the role fails before installing anything unless exactly one of `<role>_license_key` and `<role>_license_key_file` is set.

```yaml
- name: Deploy VictoriaMetrics Enterprise
  hosts: vmsingle
  become: true
  roles:
    - role: victoriametrics.cluster.vmsingle
      vars:
        vmsingle_enterprise: true
        vmsingle_license_key_file: /etc/victoriametrics/license.key
```

## Choose between a key and a key file

Use `<role>_license_key_file`.
With `<role>_license_key`, the key ends up in plain text on the target host. It is in the systemd unit or in the role's environment file, both written with mode `0644`, and it is visible in `ps` output for roles that pass it on the command line.

The roles do not copy the license file to the host. Put it there before the role runs, and make it readable by the service user.
The role creates the service group itself, but creating it first is safe and lets you set file ownership on the first run:

```yaml
- name: Deploy vmstorage Enterprise
  hosts: vmstorage
  become: true
  pre_tasks:
    - name: Create service group
      ansible.builtin.group:
        name: victoriametrics
        system: true

    - name: Create license directory
      ansible.builtin.file:
        path: /etc/victoriametrics
        state: directory
        owner: root
        group: victoriametrics
        mode: "0750"

    - name: Install license file
      ansible.builtin.copy:
        # Encrypt with ansible-vault
        src: files/license.key
        dest: /etc/victoriametrics/license.key
        owner: root
        group: victoriametrics
        mode: "0440"
  roles:
    - role: victoriametrics.cluster.vmstorage
      vars:
        vmstorage_enterprise: true
        vmstorage_license_key_file: /etc/victoriametrics/license.key
```

Use the group from the [supported roles](#supported-roles) table, or `<role>_system_group` if you override it.

If you must use `<role>_license_key`, keep the value in ansible-vault rather than in plain inventory.

## Additional license flags

The binaries accept two more license flags:

- `-license.forceOffline` verifies the license without contacting the VictoriaMetrics license server. It needs a license key issued for offline verification.
- `-licenseFile.reloadInterval` sets how often the binary re-reads `-licenseFile`. The default is 1 hour, so a renewed license file is picked up without a restart.

See [Enterprise flags](https://docs.victoriametrics.com/victoriametrics/enterprise/) for details.

For roles that pass flags on the command line, use the flag name as is:

```yaml
vmsingle_enterprise: true
vmsingle_license_key_file: /etc/victoriametrics/license.key
vmsingle_service_args:
  storageDataPath: /var/lib/victoria-metrics
  license.forceOffline: "true"
```

For `vminsert`, `vmselect` and `vmstorage`, which read flags from an environment file, replace each `.` in the flag name with `_`:

```yaml
vmstorage_enterprise: true
vmstorage_license_key_file: /etc/victoriametrics/license.key
vmstorage_config:
  retentionPeriod: "{{ vmstorage_retention_period }}"
  storageDataPath: "{{ vmstorage_data_dir }}"
  license_forceOffline: "true"
```

For `vmauth` and `vmalert`, put license flags in `vmauth_service_args` and `vmalert_service_args`, not in `vmauth_config`.
These roles validate their config with the Enterprise binary before writing it, and the validation command only passes keys from `*_service_args` whose names start with `license`.

Setting any of these dictionaries in your inventory or playbook replaces the role default entirely.
Copy the default keys from the role's `defaults/main.yml` along with your additions, as the `vmstorage_config` example above does.

## Cluster deployment

To run [playbooks/cluster.yml](playbooks/cluster.yml) with Enterprise binaries, set the Enterprise variables in `group_vars/all.yml`:

```yaml
vmstorage_enterprise: true
vmstorage_license_key_file: /etc/victoriametrics/license.key
vminsert_enterprise: true
vminsert_license_key_file: /etc/victoriametrics/license.key
vmselect_enterprise: true
vmselect_license_key_file: /etc/victoriametrics/license.key
vmauth_enterprise: true
vmauth_license_key_file: /etc/victoriametrics/license.key
```

The playbook sets `vminsert_config` and `vmselect_config` as play vars, and play vars take precedence over `group_vars`.
To add flags such as `license_forceOffline` to those components, edit the dictionaries in your copy of the playbook.

[playbooks/vlcluster.yml](playbooks/vlcluster.yml) uses the `vlsingle` role for every VictoriaLogs component, so the same `vlsingle_*` variables apply to `vlinsert`, `vlselect` and `vlstorage` hosts.

## Hosts without internet access

Target hosts need network access for two things: downloading the release archive and verifying the license. Each is handled separately.

### Download through the control node

By default, each target host downloads the release archive from `<role>_download_url` itself.
Set `<role>_install_download_to_control: true` to download on the Ansible control node instead:

```yaml
vmstorage_enterprise: true
vmstorage_license_key_file: /etc/victoriametrics/license.key
vmstorage_install_download_to_control: true
```

With this option, the role:

1. Downloads and unpacks the archive into a temporary directory on the control node, as the user running Ansible, without `become`.
2. Copies only the binary to the target host over the Ansible connection.
3. Removes the temporary directory.

The target hosts never contact GitHub, so only the control node needs access to `<role>_download_url`.
`vm_proxy_http` and `vm_proxy_https` apply to whichever host does the download, which is the control node in this mode.
For `vmsingle`, the `vmutils` archive from `vmsingle_utils_download_url` is downloaded the same way.

The download runs once per target host, and the role skips it when the host already runs `<role>_version`.
For large clusters, point `<role>_download_url` at an internal mirror of the `-enterprise` archives, close to the control node, to avoid fetching the same archive from GitHub for every host.

Each role has its own variable, so a cluster needs one per component:

```yaml
vmstorage_install_download_to_control: true
vminsert_install_download_to_control: true
vmselect_install_download_to_control: true
vmauth_install_download_to_control: true
```

## License expiry

The binaries check the license only at startup. An expired license does not stop a running process, but the next restart checks it again.
Ansible restarts the service whenever the role changes the unit file or config, so a playbook run is one of those restarts. Make sure to update the license before it expires.

