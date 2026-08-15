#################################################
# SecureBank VM Definitions
#################################################

locals {

  vm_names = {

    jenkins    = "${var.project_name}-jenkins-vm"
    sonarqube  = "${var.project_name}-sonarqube-vm"
    docker     = "${var.project_name}-docker-vm"
    monitoring = "${var.project_name}-monitoring-vm"

  }

}

resource "google_compute_instance" "securebank_vm" {

  for_each = local.vm_names

  name         = each.value
  machine_type = var.machine_type
  zone         = var.zone

  #################################################
  # Startup Script
  #################################################

 metadata_startup_script = each.key == "jenkins" ? file("${path.module}/jenkins-bootstrap.sh") : file("${path.module}/ansible-bootstrap.sh")

  #################################################
  # Tags
  #################################################

  tags = [
    var.project_name
  ]

  #################################################
  # Boot Disk
  #################################################

  boot_disk {

    initialize_params {

      image = var.image
      size  = var.disk_size

    }

  }

  #################################################
  # Network
  #################################################

  network_interface {

    subnetwork = google_compute_subnetwork.securebank_subnet.id

    access_config {}

  }

  #################################################
  # Metadata
  #################################################

  metadata = {

    enable-oslogin = "FALSE"
    vm_role        = each.key

  }

  #################################################
  # Labels
  #################################################

  labels = {

    application = var.project_name
    environment = "dev"
    owner       = "devops"
    role        = each.key

  }

}