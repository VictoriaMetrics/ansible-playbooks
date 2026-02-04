ROLES := vmsingle vmagent vmalert vminsert vmstorage vmselect vmauth vlsingle vlagent vtsingle

# Roles that have enterprise scenarios (vtsingle doesn't)
ENTERPRISE_ROLES := vmsingle vmagent vmalert vminsert vmstorage vmselect vmauth vlsingle vlagent

# License key for enterprise tests (pass via: make molecule-converge-vmsingle-enterprise VM_LICENSE_KEY=xxx)
VM_LICENSE_KEY ?=

init-venv:
	python3 -m venv .venv; \
	. .venv/bin/activate; \
	pip install -r requirements.txt; \
	ansible-galaxy collection install community.general==11.4.0 community.docker ansible.posix

lint:
	. .venv/bin/activate; \
	yamllint roles playbooks; \
	ansible-lint roles/ playbooks/

define role-default-targets
molecule-converge-$(1):
	. .venv/bin/activate; \
	cd roles/$(1) && molecule converge && molecule verify

molecule-destroy-$(1):
	. .venv/bin/activate; \
	cd roles/$(1) && molecule destroy
endef

# Template for named scenarios (proxy, download-to-control)
define role-scenario-targets
molecule-converge-$(1)-$(2):
	. .venv/bin/activate; \
	cd roles/$(1) && molecule converge -s $(2) && molecule verify -s $(2)

molecule-destroy-$(1)-$(2):
	. .venv/bin/activate; \
	cd roles/$(1) && molecule destroy -s $(2)
endef

# Template for enterprise scenarios (passes license key)
define role-enterprise-targets
molecule-converge-$(1)-enterprise:
	. .venv/bin/activate; \
	cd roles/$(1) && VM_LICENSE_KEY="$(VM_LICENSE_KEY)" molecule converge -s enterprise && molecule verify -s enterprise

molecule-destroy-$(1)-enterprise:
	. .venv/bin/activate; \
	cd roles/$(1) && molecule destroy -s enterprise
endef

# Generate default scenario targets for all roles
$(foreach role,$(ROLES),$(eval $(call role-default-targets,$(role))))

# Generate enterprise targets (only for roles that support it)
$(foreach role,$(ENTERPRISE_ROLES),$(eval $(call role-enterprise-targets,$(role))))

# Generate proxy and download-to-control targets for all roles
$(foreach role,$(ROLES),$(eval $(call role-scenario-targets,$(role),proxy)))
$(foreach role,$(ROLES),$(eval $(call role-scenario-targets,$(role),download-to-control)))

# =============================================================================
# Aggregate default/enterprise targets for debian/rocky
# =============================================================================

molecule-converge: $(addprefix molecule-converge-,$(ROLES))
molecule-converge-enterprise: $(addprefix molecule-converge-,$(addsuffix -enterprise,$(ENTERPRISE_ROLES)))
molecule-converge-proxy: $(addprefix molecule-converge-,$(addsuffix -proxy,$(ROLES)))
molecule-converge-download-to-control: $(addprefix molecule-converge-,$(addsuffix -download-to-control,$(ROLES)))

molecule-destroy: $(addprefix molecule-destroy-,$(ROLES)) molecule-destroy-cluster-integration
molecule-destroy-enterprise: $(addprefix molecule-destroy-,$(addsuffix -enterprise,$(ENTERPRISE_ROLES))) molecule-destroy-cluster-integration
molecule-destroy-proxy: $(addprefix molecule-destroy-,$(addsuffix -proxy,$(ROLES)))
molecule-destroy-download-to-control: $(addprefix molecule-destroy-,$(addsuffix -download-to-control,$(ROLES)))

molecule-converge-selinux:
	MOLECULE_DISTRO=rockylinux10 $(MAKE) molecule-converge

molecule-destroy-selinux:
	MOLECULE_DISTRO=rockylinux10 $(MAKE) molecule-destroy

# =============================================================================
# Cluster integration (playbooks/, not roles/)
# =============================================================================

molecule-converge-cluster-integration:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster

molecule-converge-cluster-integration-enterprise:
	. .venv/bin/activate; \
	cd playbooks/ && molecule converge -s cluster-enterprise

molecule-destroy-cluster-integration:
	. .venv/bin/activate; \
	cd playbooks/ && molecule destroy -s cluster

molecule-destroy-cluster-integration-enterprise:
	. .venv/bin/activate; \
	cd playbooks/ && molecule destroy -s cluster-enterprise

molecule-converge-integration: molecule-converge-cluster-integration molecule-converge-proxy molecule-converge-download-to-control
molecule-converge-integration-enterprise: molecule-converge-cluster-integration-enterprise
molecule-destroy-integration: molecule-destroy-cluster-integration
molecule-destroy-integration-enterprise: molecule-destroy-cluster-integration-enterprise
