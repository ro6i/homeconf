export EDITOR=nvim
export CLICOLOR=1
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

export PATH="/usr/local/sbin:/usr/local/opt/gnu-getopt/bin:$PATH:~/.bin:~/.local/bin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin"


if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

for BASH_CONFIG in "${HOME}/.config/bash/"*
do
  [[ -r "$BASH_CONFIG" ]] && source "$BASH_CONFIG"
done

set show-mode-in-prompt on
set vi-ins-mode-string ""
set vi-cmd-mode-string ":"

export PROMPT_CONF_TIME='on'
export PS1="\n\$(_prompt_path)\$(_prompt_component_git)\$(_prompt_jobs)\$(_prompt_time)\n "

export HISTTIMEFORMAT="%Y-%m-%dT%T "
export GREP_OPTIONS='--color=auto'

alias fresh="source ~/.bash_profile && tmux source-file ~/.tmux.conf"
alias rr="ranger"
