init-venv:
	python3 -m venv .venv; \
	. .venv/bin/activate; \
	pip install -r requirements.txt; \
	ansible-galaxy collection install community.general==11.4.0

lint:
	. .venv/bin/activate; \
	yamllint roles playbooks; \
	ansible-lint roles/ playbooks/

molecule-converge-vlagent:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule converge && molecule verify

molecule-converge-vmsingle:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge && molecule verify

molecule-converge-vmagent:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge && molecule verify

molecule-converge-vmalert:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge && molecule verify

molecule-converge-vminsert:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge && molecule verify

molecule-converge-vmstorage:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge && molecule verify

molecule-converge-vmselect:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge && molecule verify

molecule-converge-vmauth:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge && molecule verify

molecule-converge-vlagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vlsingle:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule converge && molecule verify

molecule-converge-vtsingle:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule converge && molecule verify

molecule-converge-vmsingle-enterprise:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vmagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vmalert-enterprise:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vminsert-enterprise:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vmstorage-enterprise:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vmselect-enterprise:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-vmauth-enterprise:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge -s enterprise && molecule verify -s enterprise

molecule-converge-cluster-integration:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster

molecule-converge-cluster-integration-enterprise:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster-enterprise

molecule-converge-selinux:
	MOLECULE_DISTRO=rockylinux10 $(MAKE) molecule-converge

molecule-converge-enterprise: molecule-converge-vmsingle-enterprise molecule-converge-vmagent-enterprise molecule-converge-vlagent-enterprise molecule-converge-vmalert-enterprise molecule-converge-vminsert-enterprise molecule-converge-vmstorage-enterprise molecule-converge-vmselect-enterprise molecule-converge-vmauth-enterprise

molecule-converge-integration: molecule-converge-cluster-integration molecule-converge-proxy molecule-converge-download-to-control

molecule-converge-integration-enterprise: molecule-converge-cluster-integration-enterprise

molecule-converge-vlagent-proxy:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vlagent-download-to-control:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmagent-proxy:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmagent-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmalert-proxy:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmalert-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmauth-proxy:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmauth-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmselect-proxy:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmselect-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vminsert-proxy:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vminsert-download-to-control:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vmstorage-proxy:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vmstorage-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vlsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vlsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-vtsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule converge -s proxy && molecule verify -s proxy

molecule-converge-vtsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule converge -s download-to-control && molecule verify -s download-to-control

molecule-converge-proxy: molecule-converge-vmsingle-proxy molecule-converge-vmagent-proxy molecule-converge-vlagent-proxy molecule-converge-vmalert-proxy molecule-converge-vmauth-proxy molecule-converge-vmselect-proxy molecule-converge-vminsert-proxy molecule-converge-vmstorage-proxy molecule-converge-vlsingle-proxy molecule-converge-vtsingle-proxy

molecule-converge-download-to-control: molecule-converge-vmsingle-download-to-control molecule-converge-vmagent-download-to-control molecule-converge-vlagent-download-to-control molecule-converge-vmalert-download-to-control molecule-converge-vmauth-download-to-control molecule-converge-vmselect-download-to-control molecule-converge-vminsert-download-to-control molecule-converge-vmstorage-download-to-control molecule-converge-vlsingle-download-to-control molecule-converge-vtsingle-download-to-control

molecule-destroy-vmsingle:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule destroy

molecule-destroy-vlagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule destroy -s enterprise

molecule-destroy-vlsingle:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule destroy

molecule-destroy-vtsingle:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule destroy

molecule-destroy-vmagent:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy

molecule-destroy-vmalert:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy

molecule-destroy-vminsert:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule destroy

molecule-destroy-vmstorage:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule destroy

molecule-destroy-vmselect:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule destroy

molecule-destroy-vmauth:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule destroy

molecule-destroy-vmsingle-enterprise:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule destroy -s enterprise

molecule-destroy-vmagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy -s enterprise

molecule-destroy-vmalert-enterprise:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy -s enterprise

molecule-destroy-vminsert-enterprise:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule destroy -s enterprise

molecule-destroy-vmstorage-enterprise:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule destroy -s enterprise

molecule-destroy-vmselect-enterprise:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule destroy -s enterprise

molecule-destroy-vmauth-enterprise:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule destroy -s enterprise

molecule-destroy-cluster-integration:
	. .venv/bin/activate; \
	cd playbooks/ && molecule destroy -s cluster

molecule-destroy-cluster-integration-enterprise:
	. .venv/bin/activate; \
	cd playbooks/ && molecule destroy -s cluster-enterprise

molecule-destroy-selinux:
	MOLECULE_DISTRO=rockylinux10 $(MAKE) molecule-destroy

molecule-destroy-enterprise: molecule-destroy-vmsingle-enterprise molecule-destroy-vmagent-enterprise molecule-destroy-vlagent-enterprise molecule-destroy-vmalert-enterprise molecule-destroy-vminsert-enterprise molecule-destroy-vmstorage-enterprise molecule-destroy-vmselect-enterprise molecule-destroy-vmauth-enterprise molecule-destroy-cluster-integration

molecule-destroy-integration: molecule-destroy-cluster-integration

molecule-destroy-integration-enterprise: molecule-destroy-cluster-integration-enterprise

molecule-destroy-vmsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule destroy -s proxy

molecule-destroy-vmsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule destroy -s download-to-control

molecule-destroy-vlagent-proxy:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule destroy -s proxy

molecule-destroy-vlagent-download-to-control:
	. .venv/bin/activate; \
	cd roles/vlagent && molecule destroy -s download-to-control

molecule-destroy-vmagent-proxy:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy -s proxy

molecule-destroy-vmagent-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy -s download-to-control

molecule-destroy-vmalert-proxy:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy -s proxy

molecule-destroy-vmalert-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy -s download-to-control

molecule-destroy-vmauth-proxy:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule destroy -s proxy

molecule-destroy-vmauth-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule destroy -s download-to-control

molecule-destroy-vmselect-proxy:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule destroy -s proxy

molecule-destroy-vmselect-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule destroy -s download-to-control

molecule-destroy-vminsert-proxy:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule destroy -s proxy

molecule-destroy-vminsert-download-to-control:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule destroy -s download-to-control

molecule-destroy-vmstorage-proxy:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule destroy -s proxy

molecule-destroy-vmstorage-download-to-control:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule destroy -s download-to-control

molecule-destroy-vlsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule destroy -s proxy

molecule-destroy-vlsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule destroy -s download-to-control

molecule-destroy-vtsingle-proxy:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule destroy -s proxy

molecule-destroy-vtsingle-download-to-control:
	. .venv/bin/activate; \
	cd roles/vtsingle && molecule destroy -s download-to-control

molecule-destroy-proxy: molecule-destroy-vmsingle-proxy molecule-destroy-vmagent-proxy molecule-destroy-vlagent-proxy molecule-destroy-vmalert-proxy molecule-destroy-vmauth-proxy molecule-destroy-vmselect-proxy molecule-destroy-vminsert-proxy molecule-destroy-vmstorage-proxy molecule-destroy-vlsingle-proxy molecule-destroy-vtsingle-proxy

molecule-destroy-download-to-control: molecule-destroy-vmsingle-download-to-control molecule-destroy-vmagent-download-to-control molecule-destroy-vlagent-download-to-control molecule-destroy-vmalert-download-to-control molecule-destroy-vmauth-download-to-control molecule-destroy-vmselect-download-to-control molecule-destroy-vminsert-download-to-control molecule-destroy-vmstorage-download-to-control molecule-destroy-vlsingle-download-to-control molecule-destroy-vtsingle-download-to-control
