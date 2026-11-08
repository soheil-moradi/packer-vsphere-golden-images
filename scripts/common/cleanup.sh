#!/usr/bin/env bash
set -euo pipefail

# Keep vSphere customization in charge of clone identity and networking.
sudo -n cloud-init clean --logs --seed 2>/dev/null || true
sudo -n rm -f /etc/ssh/ssh_host_* || true
sudo -n rm -f "/home/${PACKER_BUILD_USER}/.ssh/authorized_keys" || true
sudo -n rm -f /etc/sudoers.d/packer-build || true
sudo -n passwd -l "${PACKER_BUILD_USER}" || true

if [ -f /etc/machine-id ]; then
  sudo -n truncate -s 0 /etc/machine-id
fi
sudo -n rm -f /var/lib/dbus/machine-id || true
sudo -n find /var/log -type f -exec truncate -s 0 {} \; 2>/dev/null || true
sudo -n apt-get clean || true
sudo -n rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* || true
sudo -n rm -f "/home/${PACKER_BUILD_USER}"/.bash_history || true

# Packer shuts the VM down through VMware Tools after this final provisioner.
