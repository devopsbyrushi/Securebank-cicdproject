# 🚀 SecureBank Project 2026 - Phase 1
# Infrastructure Provisioning using Terraform on Google Cloud Platform (GCP)

![Terraform](https://img.shields.io/badge/Terraform-v1.8+-623CE4?style=for-the-badge&logo=terraform)
![Google Cloud](https://img.shields.io/badge/Google%20Cloud-GCP-blue?style=for-the-badge&logo=googlecloud)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?style=for-the-badge&logo=ubuntu)

---

## ☁️ GCP Project Details

| Property | Value |
|----------|-------|
| Project Name | `securebank` |
| Project ID | `securebankid` |
| Region | `us-central1` |
| Zone | `us-central1-a` |

---

# 📖 Project Overview

This repository demonstrates **Phase 1** of the **SecureBank Project 2026**, where the complete cloud infrastructure is provisioned using **Terraform** on **Google Cloud Platform (GCP)**.

The infrastructure created in this phase will be used in the upcoming phases to build a complete **DevSecOps CI/CD Pipeline** using:

- Terraform
- Ansible
- Jenkins
- SonarQube
- Docker
- Kubernetes (GKE)
- Prometheus
- Grafana

---

# 🎯 Objective

Provision the complete infrastructure required for the SecureBank Project.

The following resources will be created:

- ✅ Custom VPC
- ✅ Custom Subnet
- ✅ Firewall Rules
- ✅ Jenkins VM
- ✅ SonarQube VM
- ✅ Docker VM
- ✅ Monitoring VM (Prometheus & Grafana)
- ✅ Public IP Outputs
- ✅ Private IP Outputs

---

# 🏗️ Architecture

```text
                    Google Cloud Platform
                             │
                      Terraform Apply
                             │
              ┌──────────────────────────┐
              │   securebank-vpc │
              └──────────────────────────┘
                             │
                    securebank-subnet
                             │
     ┌─────────────┬──────────────┬──────────────┬──────────────┐
     │             │              │              │
 Jenkins VM   SonarQube VM    Docker VM    Monitoring VM
```

---

# 📂 Project Structure

```text
securebank-terraform/
│
├── versions.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── network.tf
├── firewall.tf
├── vm.tf
├── outputs.tf
└── terraform-key.json
```

---

# 💻 Virtual Machines

| VM Name | Purpose |
|----------|----------|
| securebank-jenkins-vm | Jenkins CI/CD Server |
| securebank-sonarqube-vm | SonarQube Code Quality |
| securebank-docker-vm | Docker Image Build Server |
| securebank-monitoring-vm | Prometheus & Grafana |

---

# 🌐 Network Configuration

## VPC

```
securebank-vpc
```

## Subnet

```
securebank-subnet
```

CIDR Range

```
10.10.0.0/24
```

---

# 🔥 Firewall Rules

The following TCP ports are opened.

| Port | Purpose |
|------|----------|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 8080 | Jenkins / Application |
| 8081 | Additional Application / Nexus (Optional) |
| 9000 | SonarQube |
| 3000 | Grafana |
| 9090 | Prometheus |

---

# ⚙️ Machine Configuration

| Property | Value |
|----------|-------|
| Machine Type | e2-standard-2 |
| Operating System | Ubuntu 24.04 LTS |
| Boot Disk | 30 GB |

---

# 📋 Terraform Files

| File | Description |
|------|-------------|
| versions.tf | Terraform Version Configuration |
| provider.tf | Google Cloud Provider |
| variables.tf | Input Variables |
| terraform.tfvars | Variable Values |
| network.tf | VPC & Subnet |
| firewall.tf | Firewall Rules |
| vm.tf | Compute Engine VMs |
| outputs.tf | Public & Private IP Outputs |

---

# 🚀 Deployment Steps

## Step 1

Clone the repository

```bash
git clone <repository-url>
```

---

## Step 2

Navigate to the project directory

```bash
cd securebank-terraform
```

---

## Step 3

Place the Service Account Key

```
terraform-key.json
```

inside the project folder.

---

## Step 4

Initialize Terraform

```bash
terraform init
```

---

## Step 5

Format Terraform Code

```bash
terraform fmt
```

---

## Step 6

Validate Terraform Configuration

```bash
terraform validate
```

Expected Output

```
Success! The configuration is valid.
```

---

## Step 7

Review Execution Plan

```bash
terraform plan
```

---

## Step 8

Provision Infrastructure

```bash
terraform apply
```

Type

```
yes
```

---

# 📤 Terraform Outputs

After deployment Terraform will display:

- Jenkins VM Public IP
- SonarQube VM Public IP
- Docker VM Public IP
- Monitoring VM Public IP
- VPC Name
- Subnet Name

---

# 📦 Resources Created

- Custom VPC
- Custom Subnet
- Firewall
- Jenkins VM
- SonarQube VM
- Docker VM
- Monitoring VM

---

# 📌 Next Phase

In **Phase 2**, we will automate server configuration using **Ansible**.

The following tasks will be covered:

- Install Ansible
- Passwordless SSH Authentication
- Install Java
- Install Jenkins
- Install Docker
- Install SonarQube
- Install Prometheus
- Install Grafana

---

# 👨‍💻 Author
Rushi | Rushi

**SecureBank Project 2026**

**Terraform • Google Cloud • DevSecOps • Kubernetes**
