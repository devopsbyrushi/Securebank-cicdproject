variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "cluster_name" {}
variable "node_pool_name" {}

variable "node_count" {
  default = 2
}

variable "machine_type" {
  default = "e2-medium"
}

variable "pods_secondary_range_name" {}
variable "services_secondary_range_name" {}