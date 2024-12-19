init-venv:
	python3 -m venv .venv; \
	. .venv/bin/activate; \
	pip install -r requirements.txt; \
	ansible-galaxy collection install community.general==8.3.0

lint:
	. .venv/bin/activate; \
	yamllint roles playbooks; \
	ansible-lint roles/ playbooks/

molecule-converge-vmsingle:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge -s docker

molecule-converge-vmagent:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge -s docker

molecule-converge-vmalert:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge -s docker

molecule-converge-vminsert:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge

molecule-converge-vmstorage:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge

molecule-converge-vmselect:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge

molecule-converge-vmauth:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge

molecule-converge-vlsingle:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule converge -s docker && molecule verify -s docker

molecule-converge-vmsingle-enterprise:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule converge -s docker-enterprise

molecule-converge-vmagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule converge -s docker-enterprise

molecule-converge-vmalert-enterprise:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule converge -s docker-enterprise

molecule-converge-vminsert-enterprise:
	. .venv/bin/activate; \
	cd roles/vminsert && molecule converge -s enterprise

molecule-converge-vmstorage-enterprise:
	. .venv/bin/activate; \
	cd roles/vmstorage && molecule converge -s enterprise

molecule-converge-vmselect-enterprise:
	. .venv/bin/activate; \
	cd roles/vmselect && molecule converge -s enterprise

molecule-converge-vmauth-enterprise:
	. .venv/bin/activate; \
	cd roles/vmauth && molecule converge -s enterprise

molecule-converge-cluster-integration:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster

molecule-converge-cluster-integration-enterprise:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster-enterprise

molecule-converge: molecule-converge-vmsingle molecule-converge-vmagent molecule-converge-vmalert molecule-converge-vminsert molecule-converge-vmstorage molecule-converge-vmselect molecule-converge-vmauth molecule-converge-vlsingle

molecule-converge-enterprise: molecule-converge-vmsingle-enterprise molecule-converge-vmagent-enterprise molecule-converge-vmalert-enterprise molecule-converge-vminsert-enterprise molecule-converge-vmstorage-enterprise molecule-converge-vmselect-enterprise molecule-converge-vmauth-enterprise

molecule-converge-integration: molecule-converge-cluster-integration molecule-converge-cluster-integration-enterprise

molecule-destroy-vmsingle:
	. .venv/bin/activate; \
	cd roles/vmsingle && molecule destroy -s docker

molecule-destroy-vlsingle:
	. .venv/bin/activate; \
	cd roles/vlsingle && molecule destroy -s docker

molecule-destroy-vmagent:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy -s docker

molecule-destroy-vmalert:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy -s docker

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
	cd roles/vmsingle && molecule destroy -s docker-enterprise

molecule-destroy-vmagent-enterprise:
	. .venv/bin/activate; \
	cd roles/vmagent && molecule destroy -s docker-enterprise

molecule-destroy-vmalert-enterprise:
	. .venv/bin/activate; \
	cd roles/vmalert && molecule destroy -s docker-enterprise

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

molecule-destroy: molecule-destroy-vmsingle molecule-destroy-vmagent molecule-destroy-vmalert molecule-destroy-vminsert molecule-destroy-vmstorage molecule-destroy-vmselect molecule-destroy-vmauth molecule-destroy-cluster-integration molecule-destroy-vlsingle

molecule-destroy-enterprise: molecule-destroy-vmsingle-enterprise molecule-destroy-vmagent-enterprise molecule-destroy-vmalert-enterprise molecule-destroy-vminsert-enterprise molecule-destroy-vmstorage-enterprise molecule-destroy-vmselect-enterprise molecule-destroy-vmauth-enterprise molecule-destroy-cluster-integration

molecule-destroy-integration: molecule-destroy-cluster-integration molecule-destroy-cluster-integration-enterprise
