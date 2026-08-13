# SecureBank — Fresh GCP Terraform Project

## GCP Project Details

- Project Name: `securebank`
- Project ID: `securebankid`
- Region: `us-central1`
- Zone: `us-central1-a`

## Resource Naming

The Terraform resource names have been updated from the previous
`bankingproject2026-*` naming to the new `securebank-*` naming.

Examples:
- `securebank-vpc`
- `securebank-subnet`
- `securebank-jenkins-vm`
- `securebank-sonarqube-vm`
- `securebank-docker-vm`
- `securebank-monitoring-vm`

## Fresh Deployment

This is a fresh project. Old Terraform state files are intentionally excluded.

Place the service-account key for `securebankid` in this directory as:

`terraform-key.json`

Then run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```

Review the plan before running:

```bash
terraform apply
```
