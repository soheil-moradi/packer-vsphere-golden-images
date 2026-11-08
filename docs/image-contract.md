# Golden image contract

Each image produced by this repository must satisfy the Terraform module's
template contract:

- Ubuntu Server 24.04 or Debian 13 amd64.
- Exactly one OS VMDK at SCSI unit 0.
- Exactly one `vmxnet3` network interface.
- A supported SCSI controller selected explicitly at build time.
- VMware Tools or distribution `open-vm-tools` installed and reporting guest state.
- SSH available during the build, but no build password or authorized key retained
  in the final template.
- Generic hostname, domain, machine ID, SSH host keys, DHCP leases, and logs.
- No production static IP, DNS, port group, datastore, host, or credential.
- VM powered off and converted to a template after cleanup.

Terraform adds data disks, static guest networking, hostname, domain, and any
per-VM CPU/memory settings after cloning. Do not bake application software or
company-specific Ansible configuration into these base images.
