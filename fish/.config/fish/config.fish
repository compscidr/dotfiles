# ~/.config/fish/config.fish

# 1Password account switching
# Fetches service account token (one prompt) then sets OP_SERVICE_ACCOUNT_TOKEN
# for the rest of the session - no more prompts for Ansible/Terraform
function op-personal
  set -gx OP_SERVICE_ACCOUNT_TOKEN (op read "op://Infrastructure/OP Personal Service Account/credential" --account CZG3A4373RA2FC5W5JKFUMYILI 2>/dev/null)
  if test -n "$OP_SERVICE_ACCOUNT_TOKEN"
    echo "✓ Switched to personal 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval (op signin --account CZG3A4373RA2FC5W5JKFUMYILI)
  end
end

function op-work
  set -gx OP_SERVICE_ACCOUNT_TOKEN (op read "op://Work/OP Work Service Account/credential" --account MXTDB3RE3FGANKJ2EAWMLWM2KU 2>/dev/null)
  if test -n "$OP_SERVICE_ACCOUNT_TOKEN"
    echo "✓ Switched to work 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval (op signin --account MXTDB3RE3FGANKJ2EAWMLWM2KU)
  end
end

# npm global packages
set -gx PATH $HOME/.npm-global/bin $PATH
