# Security and privacy

This repository is public by design. It must contain only generic build logic and
documentation-only examples.

- Never commit vCenter URLs, usernames, passwords, API tokens, private keys,
  datastore/cluster/network names, internal IP ranges, state, or build logs.
- Use `PKR_VAR_*` environment variables or an approved secret manager for runtime
  credentials. Packer sensitive variables redact values in normal output, but do
  not treat logs or process memory as a security boundary.
- Keep local `*.pkrvars.hcl` files ignored and mode `0600`.
- Keep `insecure_connection = false` and trust the vCenter CA.
- Verify ISO checksums from the official Ubuntu/Debian release sources.
- Use a least-privilege vCenter build account and rotate it independently from
  Terraform provisioning credentials.
