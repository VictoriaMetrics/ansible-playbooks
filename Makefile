init-venv:
	python3 -m venv .venv
	. .venv/bin/activate
	pip install -r requirements.txt
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

molecule-converge: molecule-converge-single molecule-converge-vmagent molecule-converge-vmalert

molecule-destroy-single:
	make activate-venv; \
	cd roles/single && molecule destroy -s docker

molecule-destroy-vmagent:
	make activate-venv; \
	cd roles/vmagent && molecule destroy -s docker

molecule-destroy-vmalert:
	make activate-venv; \
	cd roles/vmalert && molecule destroy -s docker

molecule-destroy: molecule-destroy-single molecule-destroy-vmagent molecule-destroy-vmalert
