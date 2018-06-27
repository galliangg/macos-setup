#!/bin/sh

#  Run this:
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/galliangg/macos-setup/master/test.sh)"
#
# It will ask you for your sudo password

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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
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
ansible-playbook test.yml -i hosts --vault-id @prompt
#ansible-playbook test.yml -i hosts -K --vault-id @prompt
#ansible-playbook playbook.yml -i hosts -K
