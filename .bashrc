
list=(
  "/usr/local/etc/bash_completion.d/brew"
  "/usr/local/etc/bash_completion.d/git-completion.bash"
  "/usr/local/etc/bash_completion.d/git-prompt.sh"
  "/usr/local/etc/bash_completion.d/tmux"
  "/usr/local/etc/bash_completion.d/scala"
  "/usr/local/etc/bash_completion.d/npm.sh"
  "/usr/local/opt/fzf/shell/completion.bash"
  "${HOME}/.config/bash/prompt"
  "${HOME}/.config/bash/cdi"
)

for item in ${list[*]}
do
  [ -r "${item}" ] && source "${item}"
done

export PATH="/usr/local/sbin:/usr/local/opt/gnu-getopt/bin:$PATH:~/.bin:~/.local/bin"

set show-mode-in-prompt on
set vi-ins-mode-string ""
set vi-cmd-mode-string ":"

export PS1="\n\$(_prompt_path)\$(_prompt_component_git)\$(_prompt_jobs)\$(_prompt_time)\n "
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
