packer {
  required_version = ">= 1.10.0, < 2.0.0"

  required_plugins {
    vsphere = {
      source  = "github.com/vmware/vsphere"
      version = "= 2.5.1"
    }
  }
}
