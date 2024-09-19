#!/bin/sh

# Welcome to the galliangg laptop script!
#
# This script bootstraps a MacOS laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs
#    - Xcode Command Line Utilities
#    - homebrew
#    - ansible via Homebrew
#  2. Kicks off the ansible playbook
#    - playbook.yml
#
#  Run this:
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/galliangg/macos-setup/master/install.sh)"
#
# It will ask you for your sudo password
#
# Ansible Vault cli command
# ansible-vault encrypt_string --name 'ansible_var_name' secret_var
#

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Boostrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
# Homebrew will install the command-line tools automatically
# Install Homebrew
if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

else
  fancy_echo "Homebrew already installed. Skipping."
fi
# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  brew install ansible
  sudo mkdir /etc/ansible
  sudo curl -L https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -o /etc/ansible/ansible.cfg
else
  fancy_echo "Ansible already installed. Skipping."
fi
# Clone the repository to your local drive.
if [ -d "./macos-setup" ]; then
  fancy_echo "Laptop repo dir exists. Removing ..."
  rm -rf ./macos-setup/
fi
fancy_echo "Cloning laptop repo ..."
git clone https://github.com/galliangg/macos-setup.git

fancy_echo "Changing to laptop repo dir ..."
cd macos-setup
# Run this from the same directory as this README file.
fancy_echo "Running ansible playbook ..."
ansible-playbook playbook.yml -i hosts -K
#ansible-playbook playbook.yml -i hosts -K
#ansible-playbook playbook.yml -i hosts
