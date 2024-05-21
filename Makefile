init-venv:
	python3 -m venv .venv; \
	. .venv/bin/activate; \
	pip install -r requirements.txt; \
	ansible-galaxy collection install community.general==8.3.0

lint:
	. .venv/bin/activate; \
	yamllint roles playbooks; \
	ansible-lint roles/ playbooks/

activate-venv:
	. .venv/bin/activate

molecule-converge-single:
	make activate-venv; \
	cd roles/single && molecule converge -s docker

molecule-converge-vmagent:
	make activate-venv; \
	cd roles/vmagent && molecule converge -s docker

molecule-converge-vmalert:
	make activate-venv; \
	cd roles/vmalert && molecule converge -s docker

molecule-converge-vminsert:
	make activate-venv; \
	cd roles/vminsert && molecule converge

molecule-converge-vmstorage:
	make activate-venv; \
	cd roles/vmstorage && molecule converge

molecule-converge-vmselect:
	make activate-venv; \
	cd roles/vmselect && molecule converge

molecule-converge-vmauth:
	make activate-venv; \
	cd roles/vmauth && molecule converge

molecule-converge-single-enterprise:
	make activate-venv; \
	cd roles/single && molecule converge -s docker-enterprise

molecule-converge-vmagent-enterprise:
	make activate-venv; \
	cd roles/vmagent && molecule converge -s docker-enterprise

molecule-converge-vmalert-enterprise:
	make activate-venv; \
	cd roles/vmalert && molecule converge -s docker-enterprise

molecule-converge-vminsert-enterprise:
	make activate-venv; \
	cd roles/vminsert && molecule converge -s enterprise

molecule-converge-vmstorage-enterprise:
	make activate-venv; \
	cd roles/vmstorage && molecule converge -s enterprise

molecule-converge-vmselect-enterprise:
	make activate-venv; \
	cd roles/vmselect && molecule converge -s enterprise

molecule-converge-vmauth-enterprise:
	make activate-venv; \
	cd roles/vmauth && molecule converge -s enterprise

molecule-converge-cluster-integration:
	make activate-venv; \
	cd playbooks/ && molecule converge -s cluster

molecule-converge-cluster-integration-enterprise:
	make activate-venv; \
	cd playbooks/ && molecule converge -s cluster-enterprise

molecule-converge: molecule-converge-single molecule-converge-vmagent molecule-converge-vmalert molecule-converge-vminsert molecule-converge-vmstorage molecule-converge-vmselect molecule-converge-vmauth

molecule-converge-enterprise: molecule-converge-single-enterprise molecule-converge-vmagent-enterprise molecule-converge-vmalert-enterprise molecule-converge-vminsert-enterprise molecule-converge-vmstorage-enterprise molecule-converge-vmselect-enterprise molecule-converge-vmauth-enterprise

molecule-converge-integration: molecule-converge-cluster-integration molecule-converge-cluster-integration-enterprise

molecule-destroy-single:
	make activate-venv; \
	cd roles/single && molecule destroy -s docker

molecule-destroy-vmagent:
	make activate-venv; \
	cd roles/vmagent && molecule destroy -s docker

molecule-destroy-vmalert:
	make activate-venv; \
	cd roles/vmalert && molecule destroy -s docker

molecule-destroy-vminsert:
	make activate-venv; \
	cd roles/vminsert && molecule destroy

molecule-destroy-vmstorage:
	make activate-venv; \
	cd roles/vmstorage && molecule destroy

molecule-destroy-vmselect:
	make activate-venv; \
	cd roles/vmselect && molecule destroy

molecule-destroy-vmauth:
	make activate-venv; \
	cd roles/vmauth && molecule destroy

molecule-destroy-single-enterprise:
	make activate-venv; \
	cd roles/single && molecule destroy -s docker-enterprise

molecule-destroy-vmagent-enterprise:
	make activate-venv; \
	cd roles/vmagent && molecule destroy -s docker-enterprise

molecule-destroy-vmalert-enterprise:
	make activate-venv; \
	cd roles/vmalert && molecule destroy -s docker-enterprise

molecule-destroy-vminsert-enterprise:
	make activate-venv; \
	cd roles/vminsert && molecule destroy -s enterprise

molecule-destroy-vmstorage-enterprise:
	make activate-venv; \
	cd roles/vmstorage && molecule destroy -s enterprise

molecule-destroy-vmselect-enterprise:
	make activate-venv; \
	cd roles/vmselect && molecule destroy -s enterprise

molecule-destroy-vmauth-enterprise:
	make activate-venv; \
	cd roles/vmauth && molecule destroy -s enterprise

molecule-destroy-cluster-integration:
	make activate-venv; \
	cd playbooks/ && molecule destroy -s cluster

molecule-destroy-cluster-integration-enterprise:
	make activate-venv; \
	cd playbooks/ && molecule destroy -s cluster-enterprise

molecule-destroy: molecule-destroy-single molecule-destroy-vmagent molecule-destroy-vmalert molecule-destroy-vminsert molecule-destroy-vmstorage molecule-destroy-vmselect molecule-destroy-vmauth molecule-destroy-cluster-integration

molecule-destroy-enterprise: molecule-destroy-single-enterprise molecule-destroy-vmagent-enterprise molecule-destroy-vmalert-enterprise molecule-destroy-vminsert-enterprise molecule-destroy-vmstorage-enterprise molecule-destroy-vmselect-enterprise molecule-destroy-vmauth-enterprise molecule-destroy-cluster-integration

molecule-destroy-integration: molecule-destroy-cluster-integration molecule-destroy-cluster-integration-enterprise
