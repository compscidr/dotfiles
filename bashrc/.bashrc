# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# add keybindings for fzf so ctrl-r uses fzf
source /usr/share/doc/fzf/examples/key-bindings.bash

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export DEBEMAIL=ernstjason1@gmail.com
export DEBFULLNAME=Jason Ernst
export MOLECULE_EPHEMERAL_DIRECTORY=~/.molecule/roles

if [ -f /etc/environment.d/90-gh.conf ]; then
    . /etc/environment.d/90-gh.conf
fi
if [ -f /etc/environment.d/90-aws.conf ]; then
    . /etc/environment.d/90-aws.conf
fi
if [ -f /etc/environment.d/90-digitalocean.conf ]; then
    . /etc/environment.d/90-digitalocean.conf
fi

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

# 1Password account switching
# Fetches service account token (one prompt) then sets OP_SERVICE_ACCOUNT_TOKEN
# for the rest of the session - no more prompts for Ansible/Terraform
op-personal() {
  export OP_SERVICE_ACCOUNT_TOKEN=$(op read "op://Infrastructure/OP_SERVICE_ACCOUNT_TOKEN/credential" --account CZG3A4373RA2FC5W5JKFUMYILI 2>/dev/null)
  if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "✓ Switched to personal 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval $(op signin --account CZG3A4373RA2FC5W5JKFUMYILI)
  fi
}

op-work() {
  export OP_SERVICE_ACCOUNT_TOKEN=$(op read "op://Service Integrations/OP_SERVICE_ACCOUNT_TOKEN/credential" --account MXTDB3RE3FGANKJ2EAWMLWM2KU 2>/dev/null)
  if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "✓ Switched to work 1Password account"
  else
    echo "✗ Failed to fetch token - falling back to interactive signin"
    eval $(op signin --account MXTDB3RE3FGANKJ2EAWMLWM2KU)
  fi
}

# Ansible/SSH host completion for managed infrastructure
_managed_hosts() {
  local hosts="
    ubuntu-beast.local
    ubuntu-silverstone.local
    ubuntu-cube.local
    ubuntu-work-laptop.local
    ubuntu-asus-laptop.local
    ubuntu-toshiba-laptop.local
    ubuntu-toshiba-mini-laptop.local
    jasons-macbook-air.local
    nas.local
    jasonernst.com
    mail.jasonernst.com
    projects.jasonernst.com
  "
  COMPREPLY=($(compgen -W "$hosts" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _managed_hosts -o default ansible-playbook ansible ssh scp

# fnm (Fast Node Manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell bash)"
fi
