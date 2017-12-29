stty -ixon

shopt -s histappend

export EDITOR=nvim
export CLICOLOR=1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export HISTIGNORE=ls:cd:pwd:nvim:jump
export GREP_OPTIONS='--color=auto'

export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/projects/work/.bin"

[[ -r "$HOME/.bash_prompt" ]] && . "$HOME/.bash_prompt"

for BASH_CONFIG in "$HOME/.config/bash/"*
do
  [[ -r "$BASH_CONFIG" ]] && . "$BASH_CONFIG"
done

eval "$(dircolors ~/.dircolors)"

export PS1="\$(_prompt_hb)\n\$(_prompt_path)\$(_prompt_jobs)\$(prompt-git)\$(prompt-env)\$(tput sgr0)\n\n "

# export CDPATH=".:$HOME/projects/work"

alias cd='cd -P'
alias ll='ls -l --color=auto'
alias cp="cp -i"
alias free='free -m'
alias reboot='sudo reboot now; history -d $(history 1)'

mkdircd() {
  mkdir "$1" && cd "$1"
}

cdi() {
    tempfile="$(mktemp -t cdi.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

keyring-unlock() {
  read -rsp "Password: " _pass
  export $(echo -n "$_pass" | gnome-keyring-daemon --replace --unlock)
  unset _pass
}

alias fresh="source ~/.bash_profile && tmux source-file ~/.tmux.conf"
alias rr='ranger'
alias tmux='systemd-run --scope --user tmux'

[ -f "$GOOGLE_CLOUD_SDK_HOME/path.bash.inc" ]       && . "$GOOGLE_CLOUD_SDK_HOME/path.bash.inc"
[ -f "$GOOGLE_CLOUD_SDK_HOME/completion.bash.inc" ] && . "$GOOGLE_CLOUD_SDK_HOME/completion.bash.inc"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

shopt -s cmdhist
shopt -s lithist
HISTTIMEFORMAT='%F %T '

eval "$(direnv hook bash)"

export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/robi/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
