# 🧱 VMware vSphere Golden Images with Packer

[![Packer validation](https://github.com/soheil-moradi/packer-vsphere-golden-images/actions/workflows/packer-ci.yml/badge.svg?branch=main)](https://github.com/soheil-moradi/packer-vsphere-golden-images/actions/workflows/packer-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Packer](https://img.shields.io/badge/Packer-1.10%2B-02A8EF?logo=packer&logoColor=white)](https://developer.hashicorp.com/packer)
[![VMware](https://img.shields.io/badge/VMware-vSphere%207%20%7C%208-607078?logo=vmware&logoColor=white)](https://developer.hashicorp.com/packer/integrations/vmware/vsphere/latest/components/builder/vsphere-iso)

Reusable, manually initiated Packer builds for versioned Ubuntu Server 24.04 and
Debian 13 VMware vSphere golden images designed for Terraform cloning.

This is a public, generic repository. It must never contain company inventory,
credentials, private IP ranges, state, build logs, or real environment variable
files. All vCenter placement values are runtime inputs.

## 🧭 Architecture

```text
Packer + official ISO
        │
        ▼
Immutable vSphere template
        │
        ▼
Terraform clone + vSphere guest customization
        │
        ▼
Ansible OS and application configuration
```

Packer owns the operating-system baseline. Terraform owns VM placement, cloning,
static guest customization, disks, and per-VM sizing. Ansible owns post-provisioning.

## 🧰 Supported images

- Ubuntu Server 24.04 amd64
- Debian 13 (trixie) amd64
- vCenter 7 and vCenter 8 through the VMware `vsphere-iso` builder
- One OS disk and one `vmxnet3` NIC, matching the Terraform template contract

See [the image contract](docs/image-contract.md) before changing the build.

## 📁 Repository layout

```text
.
├── builds/                  # vsphere-iso sources and build blocks
├── http/                    # unattended Ubuntu/Debian installer templates
├── scripts/common/          # baseline installation and cleanup
├── examples/                # placeholder-only local variable example
├── docs/                    # contract, workflow, security, verification
├── tests/                   # public-tree safety checks
├── versions.pkr.hcl         # Packer and plugin constraints
└── variables.pkr.hcl        # runtime and build inputs
```

## 🚦 Manual workflow

Packer builds are never started automatically by CI. CI only formats and validates
the configuration. To build manually:

```bash
packer init .
packer fmt -check -recursive
packer validate -var-file=local.pkrvars.hcl .
packer build -only=vsphere-iso.ubuntu_2404 -var-file=local.pkrvars.hcl builds
```

Read [the build workflow](docs/build-workflow.md) and [verification checklist](docs/verification.md)
before running a real build. Do not run a real build against company infrastructure
until the target values, guest OS identifiers, hardware version, and approvals are
confirmed.

## 🔐 Credentials and private values

Use `PKR_VAR_vsphere_server`, `PKR_VAR_vsphere_user`, `PKR_VAR_vsphere_password`,
and other `PKR_VAR_*` variables or an approved secret manager. Keep local
`*.pkrvars.hcl` files ignored and never paste credentials into this repository.
See [security guidance](docs/security.md).

## 🧪 Testing

The repository includes a public-tree safety test. Packer validation requires the
Packer CLI and the pinned VMware plugin; no vCenter connection is required for
syntax validation.

```bash
python3 -m unittest discover -s tests -v
packer init .
packer fmt -check -recursive
packer validate .
```

## 🔗 Related project

The Terraform consumer is maintained separately in
[`terraform-vsphere-vm`](https://github.com/soheil-moradi/terraform-vsphere-vm).
Terraform maps stable OS aliases to the exact immutable template names produced by
this repository.
