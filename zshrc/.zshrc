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

# 1Password account switching
# Fetches service account token (one prompt) then sets OP_SERVICE_ACCOUNT_TOKEN
# for the rest of the session - no more prompts for Ansible/Terraform
op-personal() {
  export OP_SERVICE_ACCOUNT_TOKEN=$(op read "op://Infrastructure/OP Personal Service Account/credential" --account CZG3A4373RA2FC5W5JKFUMYILI 2>/dev/null)
  if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "✓ Switched to personal 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval $(op signin --account CZG3A4373RA2FC5W5JKFUMYILI)
  fi
}

op-work() {
  export OP_SERVICE_ACCOUNT_TOKEN=$(op read "op://Work/OP Work Service Account/credential" --account MXTDB3RE3FGANKJ2EAWMLWM2KU 2>/dev/null)
  if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "✓ Switched to work 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval $(op signin --account MXTDB3RE3FGANKJ2EAWMLWM2KU)
  fi
}

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
