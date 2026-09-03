Development roadmap

We'll work through roughly these stages:

Repository + Ansible project foundation — ansible.cfg, YAML inventory, groups, host patterns, connectivity, privilege escalation and first production-style playbook.
Variables and facts — group_vars, host_vars, precedence, ansible_facts, register, loops, conditions and assertions.
Role development — convert playbooks into reusable roles; defaults, vars, handlers, templates, task includes and role dependencies.
Linux pre-patching framework — disk, memory, uptime, kernel, services, package status, filesystem capacity and reboot state.
Multi-OS patch engine — Ubuntu/APT, RHEL/DNF and SUSE/Zypper through OS-specific role logic.
Production patch orchestration — serial, max_fail_percentage, blocks, rescue, always, controlled reboot and failure recovery.
Post-patch validation + reporting — service checks, kernel verification, application checks, consolidated HTML/CSV.
Security — SSH, become, Vault, secrets, service accounts and production credential patterns.
Quality engineering — idempotency, check mode, diff mode, ansible-lint, Molecule and testing.
AWS automation — collections, EC2 dynamic inventory and selected provisioning/configuration use cases.
Terraform + Ansible — clear ownership boundaries and Terraform → configuration workflow.
CI/CD — GitLab CI first, then GitHub Actions, including lint/test/check/run/report artifacts.
AWX / Automation Controller — inventories, credentials, projects, job templates, workflows, RBAC and scheduling.
Production scenarios + live coding — write/debug playbooks and explain architectural decisions under interview conditions.

The important thing is that every interview answer will come from code you have actually developed.