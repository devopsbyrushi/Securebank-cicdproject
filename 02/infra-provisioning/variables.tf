#################################################
# Google Cloud Configuration
#################################################

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "zone" {
  description = "Google Cloud Zone"
  type        = string
}

#################################################
# Banking Project
#################################################

variable "project_name" {
  description = "Project Name"
  default     = "securebank"
}

#################################################
# Network
#################################################

variable "network_name" {
  default = "securebank-vpc"
}

variable "subnet_name" {
  default = "securebank-subnet"
}

variable "subnet_cidr" {
  default = "10.10.0.0/24"
}

#################################################
# Compute Engine
#################################################

variable "machine_type" {
  default = "e2-standard-2"
}

variable "disk_size" {
  default = 30
}

variable "image" {
  default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}