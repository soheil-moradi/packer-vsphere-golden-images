# Manual build workflow

Builds are intentionally manual. GitHub Actions may format and validate the
configuration, but it must not connect to vCenter or publish templates.

## Prepare runtime values

Copy the public example to an ignored local file and set values only on the local
build host or approved secret mechanism. Credential variables can also be passed
as `PKR_VAR_*` environment variables.

```bash
cp examples/public.pkrvars.hcl.example local.pkrvars.hcl
chmod 600 local.pkrvars.hcl
```

The example contains placeholders only. Replace ISO URLs and checksums with the
official release artifacts selected for the build, and verify the ESXi-supported
guest OS identifiers locally.

## Validate and build

```bash
packer init .
packer fmt -check -recursive
packer validate -var-file=local.pkrvars.hcl .
packer build -only=vsphere-iso.ubuntu_2404 -var-file=local.pkrvars.hcl .
packer build -only=vsphere-iso.debian_13 -var-file=local.pkrvars.hcl .
```

Run one OS build at a time until the image contract is accepted. Do not enable
`-debug` or verbose tracing in ordinary builds if it could expose runtime values.

## Naming and release metadata

The template names are immutable and include OS, image version, and hardware
version, for example `tmpl-ubuntu-2404-v1.0.0-hw19`. Record the ISO checksum,
Packer version, plugin version, build operator, and verification result in the
release notes. Terraform consumes the exact template name through its private
environment alias map.
