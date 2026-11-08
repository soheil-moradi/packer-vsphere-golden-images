#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo -n apt-get update
sudo -n apt-get -y upgrade
sudo -n apt-get install -y \
  ca-certificates \
  open-vm-tools \
  openssh-server \
  python3 \
  python3-apt \
  sudo

sudo -n systemctl enable open-vm-tools.service || true
sudo -n systemctl enable ssh.service || sudo -n systemctl enable sshd.service || true
sudo -n systemctl start open-vm-tools.service || true
sudo -n systemctl start ssh.service || sudo -n systemctl start sshd.service || true

# The Packer build account is temporary and must not remain privileged in the image.
sudo -n install -d -m 0750 -o "${PACKER_BUILD_USER}" -g "${PACKER_BUILD_USER}" \
  "/home/${PACKER_BUILD_USER}/.ssh"
