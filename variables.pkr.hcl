variable "vsphere_server" {
  type        = string
  sensitive   = true
  description = "vCenter FQDN or IP supplied at build time through PKR_VAR_vsphere_server."
}

variable "vsphere_user" {
  type        = string
  sensitive   = true
  description = "Least-privilege vCenter build account supplied through PKR_VAR_vsphere_user."
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "vCenter build account password supplied through PKR_VAR_vsphere_password."
}

variable "vsphere_datacenter" {
  type        = string
  description = "Target Datacenter name. Keep real values in an ignored local .pkrvars.hcl file."
}

variable "vsphere_cluster" {
  type        = string
  description = "Target cluster name."
}

variable "vsphere_host" {
  type        = string
  default     = null
  description = "Optional ESXi host. Set it when the build datastore is host-local."
}

variable "vsphere_datastore" {
  type        = string
  description = "Target datastore name."
}

variable "vsphere_network" {
  type        = string
  description = "Temporary build network display name."
}

variable "vsphere_folder" {
  type        = string
  default     = null
  description = "Optional VM folder for the temporary build VM and resulting template."
}

variable "vsphere_resource_pool" {
  type        = string
  default     = null
  description = "Optional full resource-pool path."
}

variable "vsphere_insecure_connection" {
  type        = bool
  default     = false
  description = "Disable vCenter TLS verification. Keep false and trust the vCenter CA."
}

variable "vm_version" {
  type        = number
  description = "Explicit virtual hardware version compatible with every eligible ESXi host."
}

variable "vm_cpus" {
  type        = number
  default     = 2
  description = "Temporary build VM vCPU count."
}

variable "vm_memory_mb" {
  type        = number
  default     = 2048
  description = "Temporary build VM memory in MB."
}

variable "vm_disk_size_mb" {
  type        = number
  default     = 40960
  description = "Primary OS disk size in MB. The Terraform module expects one OS disk at SCSI unit 0."
}

variable "vm_scsi_controller" {
  type        = string
  default     = "lsilogic-sas"
  description = "SCSI controller type supported by the selected guest and ESXi hosts."
}

variable "vm_network_card" {
  type        = string
  default     = "vmxnet3"
  description = "The single NIC type required by the Terraform template contract."
}

variable "image_version" {
  type        = string
  default     = "0.1.0-dev"
  description = "Immutable image version used in the resulting template name."
}

variable "build_ssh_username" {
  type        = string
  default     = "packer"
  description = "Temporary installer/build account name."
}

variable "build_ssh_password" {
  type        = string
  sensitive   = true
  description = "Temporary build account password supplied at runtime; never store it in this repository."
}

variable "build_password_hash" {
  type        = string
  sensitive   = true
  description = "SHA-512 crypt password hash used only by the unattended installers."
}

variable "build_ssh_timeout" {
  type        = string
  default     = "30m"
  description = "Maximum time to wait for SSH after installation."
}

variable "ubuntu_iso_url" {
  type        = string
  description = "Official Ubuntu Server 24.04 amd64 ISO URL."
}

variable "ubuntu_iso_checksum" {
  type        = string
  description = "Ubuntu ISO checksum, for example sha256:<digest>."
}

variable "ubuntu_guest_os_type" {
  type        = string
  description = "Guest OS identifier accepted by the target ESXi host for Ubuntu 24.04."
}

variable "debian_iso_url" {
  type        = string
  description = "Official Debian 13 amd64 netinst ISO URL."
}

variable "debian_iso_checksum" {
  type        = string
  description = "Debian ISO checksum, for example sha512:<digest>."
}

variable "debian_guest_os_type" {
  type        = string
  description = "Guest OS identifier accepted by the target ESXi host for Debian 13."
}
