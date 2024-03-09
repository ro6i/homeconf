stty -ixon

shopt -s histappend

export EDITOR=nvim
export CLICOLOR=1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# export HISTTIMEFORMAT="%Y-%m-%dT%T "
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export GREP_OPTIONS='--color=auto'

export TZ='Asia/Tbilisi'

export PATH="$PATH:$HOME/.bin:$HOME/.local/bin:~/projects/endowus/.bin"
export PATH="$PATH:~/node_modules/.bin"
# export PATH="/usr/local/sbin:$PATH"

for BASH_CONFIG in "${HOME}/.config/bash/"*
do
  [[ -r "$BASH_CONFIG" ]] && . "$BASH_CONFIG"
done

export PROMPT_CONF_TIME=yes

eval "$(dircolors ~/.dir_colors)"

export PS1="\$(_prompt_hb)\n\n\$(_prompt_path)\$(_prompt_jobs)\$(_prompt__git)\$(_prompt_env)\$(tput sgr0)\n\n "
#export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

alias cd='cd -P'
alias ll='ls -l --color=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias free='free -m'                      # show sizes in MB
# alias rm='trash'
alias reboot='sudo reboot now; history -d $(history 1)'

mkdircd() {
  mkdir "$1" && cd "$1"
}

alias fresh="source ~/.bash_profile && tmux source-file ~/.tmux.conf"
alias rr='ranger'
alias tmux='systemd-run --scope --user tmux'

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

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
