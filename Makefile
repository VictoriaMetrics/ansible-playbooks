init-venv:
	python3 -m venv .venv
	. .venv/bin/activate
	pip install -r requirements.txt
	ansible-galaxy collection install community.general==8.3.0

venv:
	. .venv/bin/activate

lint: venv
	yamllint roles playbooks
	ansible-lint roles/ playbooks/

molecule-converge: venv
	cd roles/single && molecule converge -s docker
	cd roles/vmagent && molecule converge -s docker
	cd roles/vmalert && molecule converge -s docker

molecule-destroy: venv
	cd roles/single && molecule destroy -s docker
	cd roles/vmagent && molecule destroy -s docker
	cd roles/vmalert && molecule destroy -s docker
