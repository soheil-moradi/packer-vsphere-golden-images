# Verification checklist

After a manual build, verify the resulting template in a disposable lab before
using it as a Terraform source.

## vSphere inventory

- The VM is powered off and marked as a template.
- The name matches the immutable versioning convention.
- The hardware version is supported by every target ESXi host.
- The VM has one OS disk at SCSI unit 0 and one `vmxnet3` NIC.
- No ISO, floppy, snapshot, temporary build network, or unexpected extra disk remains.

## Guest behavior

- `open-vm-tools` is installed and VMware Tools reports the guest IP.
- The build account is locked or removed, its authorized keys are gone, and no
  build password remains in the image.
- SSH host keys and `/etc/machine-id` are absent or regenerated on first boot.
- No static IP, company DNS, hostname, internal repository, or production agent remains.
- Ubuntu/Debian package state is clean and security updates are documented.

## Terraform integration

In a disposable Terraform environment, clone one image and verify guest
customization, hostname, domain, static IPv4, DNS, VMware Tools network reporting,
OS disk growth, and named data disk behavior. Test CPU/Memory Hot Add only when the
guest OS and virtual hardware support it.
