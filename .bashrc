source "${HOME}/.config/bash/prompt"
source "${HOME}/.config/bash/cdi"

export PATH="/usr/local/sbin:$PATH:~/.bin:~/.local/bin"

set show-mode-in-prompt on
set vi-ins-mode-string ""
set vi-cmd-mode-string ":"

export PS1="\n\$(prompt_path)\$(prompt_component_git)\$(prompt_time)\n "
# export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%Y-%m-%dT%T "
export EDITOR=nvim
export CLICOLOR=1
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export GREP_OPTIONS='--color=auto'

# alias vim="nvim"
alias mitmproxy="mitmproxy --set console_palette=solarized_dark --set console_palette_transparent=true"
alias rr="ranger"

alias fresh_bash="source ~/.bash_profile"
alias fresh_tmux="tmux source-file ~/.tmux.conf"
