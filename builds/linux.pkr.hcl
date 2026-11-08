source "vsphere-iso" "ubuntu_2404" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  datacenter    = var.vsphere_datacenter
  cluster       = var.vsphere_cluster
  host          = var.vsphere_host
  datastore     = var.vsphere_datastore
  folder        = var.vsphere_folder
  resource_pool = var.vsphere_resource_pool

  vm_name          = local.ubuntu_template_name
  vm_version       = var.vm_version
  guest_os_type    = var.ubuntu_guest_os_type
  CPUs             = var.vm_cpus
  RAM              = var.vm_memory_mb
  CPU_hot_plug     = false
  RAM_hot_plug     = false
  disk_size        = var.vm_disk_size_mb
  disk_controller_type = [var.vm_scsi_controller]
  disk_thin_provisioned = true

  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }

  iso_url      = var.ubuntu_iso_url
  iso_checksum = var.ubuntu_iso_checksum

  http_content = {
    "/ubuntu-2404/user-data" = templatefile("${path.root}/http/ubuntu-2404/user-data.tmpl", {
      build_ssh_username = var.build_ssh_username
      build_password_hash = var.build_password_hash
    })
    "/ubuntu-2404/meta-data" = file("${path.root}/http/ubuntu-2404/meta-data")
  }

  boot_command = [
    "<wait><esc><wait><f6><wait><esc><wait>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu-2404/ ---<enter>",
  ]

  communicator       = "ssh"
  ssh_username       = var.build_ssh_username
  ssh_password       = var.build_ssh_password
  ssh_timeout        = var.build_ssh_timeout
  shutdown_timeout   = "10m"
  convert_to_template = true

  notes = "Built by Packer from an official Ubuntu Server 24.04 ISO. See the image manifest for source metadata."
}

source "vsphere-iso" "debian_13" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  datacenter    = var.vsphere_datacenter
  cluster       = var.vsphere_cluster
  host          = var.vsphere_host
  datastore     = var.vsphere_datastore
  folder        = var.vsphere_folder
  resource_pool = var.vsphere_resource_pool

  vm_name          = local.debian_template_name
  vm_version       = var.vm_version
  guest_os_type    = var.debian_guest_os_type
  CPUs             = var.vm_cpus
  RAM              = var.vm_memory_mb
  CPU_hot_plug     = false
  RAM_hot_plug     = false
  disk_size        = var.vm_disk_size_mb
  disk_controller_type = [var.vm_scsi_controller]
  disk_thin_provisioned = true

  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }

  iso_url      = var.debian_iso_url
  iso_checksum = var.debian_iso_checksum

  http_content = {
    "/debian-13/preseed.cfg" = templatefile("${path.root}/http/debian-13/preseed.cfg.tmpl", {
      build_ssh_username = var.build_ssh_username
      build_password_hash = var.build_password_hash
    })
  }

  boot_command = [
    "<wait><esc><wait>",
    "auto=true priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian-13/preseed.cfg ---<enter>",
  ]

  communicator       = "ssh"
  ssh_username       = var.build_ssh_username
  ssh_password       = var.build_ssh_password
  ssh_timeout        = var.build_ssh_timeout
  shutdown_timeout   = "10m"
  convert_to_template = true

  notes = "Built by Packer from an official Debian 13 ISO. See the image manifest for source metadata."
}

build {
  name = "ubuntu-2404"

  sources = [
    "source.vsphere-iso.ubuntu_2404",
  ]

  provisioner "shell" {
    script = "${path.root}/scripts/common/prepare-base.sh"

    environment_vars = [
      "PACKER_BUILD_USER=${var.build_ssh_username}",
    ]
  }

  provisioner "shell" {
    script = "${path.root}/scripts/common/cleanup.sh"

    environment_vars = [
      "PACKER_BUILD_USER=${var.build_ssh_username}",
    ]
  }
}

build {
  name = "debian-13"

  sources = [
    "source.vsphere-iso.debian_13",
  ]

  provisioner "shell" {
    script = "${path.root}/scripts/common/prepare-base.sh"

    environment_vars = [
      "PACKER_BUILD_USER=${var.build_ssh_username}",
    ]
  }

  provisioner "shell" {
    script = "${path.root}/scripts/common/cleanup.sh"

    environment_vars = [
      "PACKER_BUILD_USER=${var.build_ssh_username}",
    ]
  }
}
