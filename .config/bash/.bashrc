source "${BASH_SOURCE%/*}/.bashrc_prompt"

export PATH="$PATH:~/.bin:/usr/local/sbin:~/.local/bin"

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
alias fresh="source ~/.bash_profile"

function git-log() {
  git log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(cyan)%aD%C(reset) %C(green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' "$@"
#--all
}
function git-branch-delete() {
  git branch | grep "$@" | sed -e 's/^[ ]*//' -e 's/[ ]*$//' | xargs git branch -D
}
function git-author-stat() {
  git ls-files | while read f; do git blame -w -M -C -C --line-porcelain "$f" | grep '^author '; done | sort -f | uniq -ic | sort -n
}

gap() {
  for i in `seq 1 5`; do echo; done
}

# start ranger; change the shell path upon exiting ranger
cdi() {
  tempfile="$(mktemp -t tmp.XXXXXX)"
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}
