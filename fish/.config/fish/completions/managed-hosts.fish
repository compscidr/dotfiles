# Managed infrastructure host completions
# Shared completion for ansible-playbook, ansible, ssh, scp

set -l managed_hosts \
  ubuntu-beast.local \
  ubuntu-silverstone.local \
  ubuntu-cube.local \
  ubuntu-work-laptop.local \
  ubuntu-asus-laptop.local \
  ubuntu-toshiba-laptop.local \
  ubuntu-toshiba-mini-laptop.local \
  jasons-macbook-air.local \
  nas.local \
  jasonernst.com \
  mail.jasonernst.com \
  projects.jasonernst.com

# SSH/SCP completions
complete -c ssh -a "$managed_hosts" -d "Managed host"
complete -c scp -a "$managed_hosts" -d "Managed host"

# Ansible completions (for --limit flag and positional args)
complete -c ansible -a "$managed_hosts" -d "Managed host"
complete -c ansible-playbook -l limit -a "$managed_hosts" -d "Managed host"
