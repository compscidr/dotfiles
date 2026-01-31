# ~/.zshrc - macOS zsh configuration

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Enable completion system
autoload -Uz compinit
compinit

# 1Password account signin shortcuts
alias op-personal='eval $(op signin --account CZG3A4373RA2FC5W5JKFUMYILI)'  # ernstjason1@gmail.com
alias op-work='eval $(op signin --account MXTDB3RE3FGANKJ2EAWMLWM2KU)'      # jason@bumpapp.xyz

# Ansible/SSH host completion for managed infrastructure
_managed_hosts=(
  'ubuntu-beast.local'
  'ubuntu-silverstone.local'
  'ubuntu-cube.local'
  'ubuntu-work-laptop.local'
  'ubuntu-asus-laptop.local'
  'ubuntu-toshiba-laptop.local'
  'ubuntu-toshiba-mini-laptop.local'
  'jasons-macbook-air.local'
  'nas.local'
  'jasonernst.com'
  'mail.jasonernst.com'
  'projects.jasonernst.com'
)

_ansible_host_completion() {
  _describe 'managed hosts' _managed_hosts
}

compdef _ansible_host_completion ansible-playbook ansible ssh scp
