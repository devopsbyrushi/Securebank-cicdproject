# SecureBank Project 2026 - Phase 2
# Ansible Configuration Management on Ubuntu 24.04 LTS

## GCP Project Details

| Property | Value |
|----------|-------|
| Project Name | `securebank` |
| Project ID | `securebankid` |
| Region | `us-central1` |
| Zone | `us-central1-a` |

---

# Phase 2 Objective

Phase 2 configures the four VMs created in Phase 1 using Ansible.

The servers are:

- Jenkins VM
- Docker VM
- SonarQube VM
- Monitoring VM (Prometheus + Grafana)

The Phase 2 automation covers:

- Ansible controller setup
- Passwordless SSH
- Ansible inventory
- Common packages
- Docker
- Prometheus
- Grafana
- SonarQube
- Jenkins
- Basic verification
- Optional cleanup playbook

---

# Lab Architecture

```text
                         SecureBank Project
                              |
                       GCP Infrastructure
                              |
             +----------------+----------------+
             |                |                |
          Jenkins           Docker          SonarQube
          :8080             Docker             :9000
             |
             +----------------+----------------+
                              |
                         Monitoring
                      Prometheus :9090
                        Grafana :3000
```

---

# Current VM Public IPs

These are the public IPs from the successful Phase 1 deployment. They can change if the VMs are recreated or their ephemeral addresses change.

| Server | Public IP | Ansible Group |
|--------|-----------|---------------|
| Jenkins | `35.255.7.56` | `jenkins` |
| Docker | `35.225.115.138` | `docker` |
| Monitoring | `136.114.122.132` | `monitoring` |
| SonarQube | `34.66.36.10` | `sonar` |

---

# 1. Install Ansible

On the Ubuntu 24.04 Ansible Controller:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install ansible -y
ansible --version
```

Create the Ansible directory if required:

```bash
sudo mkdir -p /etc/ansible
```

---

# 2. Configure Ansible

Edit:

```bash
sudo nano /etc/ansible/ansible.cfg
```

Use:

```ini
[defaults]
inventory=/etc/ansible/hosts
host_key_checking=False
remote_user=YOUR_GCP_SSH_USER
forks=5
timeout=30
```

Replace `YOUR_GCP_SSH_USER` with the Linux username that you use to SSH into the SecureBank VMs.

---

# 3. Configure Inventory

The supplied inventory is:

```text
01.hosts
```

Copy it to:

```bash
sudo cp 01.hosts /etc/ansible/hosts
```

Before testing, replace:

```text
YOUR_GCP_SSH_USER
```

with your actual Linux SSH username.

The inventory groups are:

```ini
[docker]
35.225.115.138

[monitoring]
136.114.122.132

[sonar]
34.66.36.10

[jenkins]
35.255.7.56
```

The Jenkins group is named `jenkins` so that it matches the Jenkins playbook.

---

# 4. Passwordless SSH

On the Ansible Controller:

```bash
ssh-keygen
```

Display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

Add the public key to the `~/.ssh/authorized_keys` file of each managed VM.

Then verify:

```bash
ssh YOUR_GCP_SSH_USER@35.255.7.56
ssh YOUR_GCP_SSH_USER@35.225.115.138
ssh YOUR_GCP_SSH_USER@136.114.122.132
ssh YOUR_GCP_SSH_USER@34.66.36.10
```

Do not proceed until SSH works.

---

# 5. Test Ansible Connectivity

Run:

```bash
ansible all -m ping
```

Then:

```bash
ansible all -a "hostname"
ansible all -a "df -h"
ansible all -a "free -h"
ansible all -a "uptime"
```

Expected result:

```text
SUCCESS
```

for all four servers.

---

# 6. Configure Passwordless Sudo

On each managed VM:

```bash
sudo visudo
```

Add:

```text
YOUR_GCP_SSH_USER ALL=(ALL) NOPASSWD:ALL
```

Verify:

```bash
sudo -l
```

This is required because the supplied playbooks use:

```yaml
become: yes
```

---

# 7. Run Common Packages Playbook

```bash
ansible-playbook 02.Basic-Packages-install.yaml
```

This installs the common packages from the supplied Phase 2 playbook, including:

- Git
- curl
- wget
- unzip
- vim
- tree
- zip
- net-tools
- htop
- software-properties-common

---

# 8. Install Docker

Run:

```bash
ansible-playbook 03-dockerinstall.yaml
```

Target:

```text
Docker VM
```

Verify:

```bash
ansible docker -a "docker --version"
```

---

# 9. Configure Monitoring

Run:

```bash
ansible-playbook 04-monitoring.yaml
```

The supplied playbook installs Docker and runs:

```text
Prometheus → port 9090
Grafana    → port 3000
```

Verify:

```bash
ansible monitoring -a "docker ps"
```

---

# 10. Install SonarQube

Run:

```bash
ansible-playbook 05.sonarqube-install.yaml
```

The supplied playbook configures:

- Java 21
- PostgreSQL
- SonarQube
- SonarQube database
- SonarQube systemd service
- Port 9000

Verify:

```bash
ansible sonar -a "systemctl is-active sonarqube" --become
```

---

# 11. Install Jenkins

Run:

```bash
ansible-playbook 06.Jenkins-install.yml
```

The supplied playbook configures:

- Java 21
- Maven
- Docker
- Jenkins repository
- Jenkins
- Jenkins systemd service
- Port 8080

Verify:

```bash
ansible jenkins -a "systemctl is-active jenkins" --become
```

---

# 12. Phase 2 Verification

Check all groups:

```bash
ansible all -m ping
```

Check Docker:

```bash
ansible docker -a "docker --version"
```

Check Jenkins:

```bash
ansible jenkins -a "systemctl is-active jenkins" --become
```

Check SonarQube:

```bash
ansible sonar -a "systemctl is-active sonarqube" --become
```

Check Monitoring:

```bash
ansible monitoring -a "docker ps"
```

---

# 13. Optional Cleanup

The supplied cleanup playbook is:

```text
07.Uninstall.yaml
```

It targets:

```text
docker
monitoring
sonar
```

and intentionally keeps Jenkins.

Run it only when you actually want to remove the Phase 2 software from those servers:

```bash
ansible-playbook 07.Uninstall.yaml
```

---

# Phase 2 Completion

Phase 2 is complete when:

```text
Ansible Controller
       |
       +----> Jenkins VM       → Jenkins :8080
       |
       +----> Docker VM        → Docker
       |
       +----> SonarQube VM     → SonarQube :9000
       |
       +----> Monitoring VM    → Prometheus :9090
                                  Grafana :3000
```

After successful verification, we can move to the next project phase.

---

# Important Notes

1. This is a fresh SecureBank project. Do not reuse the deleted project's Terraform state.
2. The VM public IPs above are the values from the successful Phase 1 deployment and may change if the VMs are recreated.
3. Replace `YOUR_GCP_SSH_USER` with the actual Linux username used for SSH.
4. The inventory uses the group name `jenkins`; this matches the Jenkins playbook.
5. Run and verify each playbook separately rather than running every playbook at once.
