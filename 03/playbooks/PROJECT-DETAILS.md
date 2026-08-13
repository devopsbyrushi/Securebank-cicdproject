# SecureBank Phase 2

Project Name: `securebank`
Project ID: `securebankid`
Region: `us-central1`
Zone: `us-central1-a`

Phase 1 Terraform infrastructure is already deployed.

Phase 2 uses Ansible to configure:
- Jenkins
- Docker
- SonarQube
- Prometheus
- Grafana

Current VM IPs are documented in `Ansible Configuration Management.md`.

Before running playbooks, replace `YOUR_GCP_SSH_USER` in `01.hosts` with the Linux username used for SSH.
