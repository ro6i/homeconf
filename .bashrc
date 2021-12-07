shopt -s histappend

export EDITOR=nvim
export CLICOLOR=1
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export HISTTIMEFORMAT="%Y-%m-%dT%T "
export GREP_OPTIONS='--color=auto'

export PATH="$PATH:$HOME/.bin:$HOME/.local/bin:~/projects/.bin"
export PATH="$PATH:~/node_modules/.bin"
# export PATH="/usr/local/sbin:$PATH"

for BASH_CONFIG in "${HOME}/.config/bash/"*
do
  [[ -r "$BASH_CONFIG" ]] && source "$BASH_CONFIG"
done

export PROMPT_CONF_TIME=on

export PS1="\$(_prompt_hb)\n\$(_prompt_path)\$(_prompt_jobs)\$(_prompt_component_git)\n "
#export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

alias cd='cd -P'
alias ll='ls -l'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
# alias rm='trash'

alias fresh="source ~/.bash_profile && tmux source-file ~/.tmux.conf"
alias rr='ranger'

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

#eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

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

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f ~/.bin/kiq.sh ]] && source ~/.bin/kiq.sh

GOOGLE_CLOUD_SDK_PATH="$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
GOOGLE_CLOUD_SDK_PATH="$HOME/.install/google-cloud-sdk"
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$GOOGLE_CLOUD_SDK_PATH/path.bash.inc" ]; then . "$GOOGLE_CLOUD_SDK_PATH/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$GOOGLE_CLOUD_SDK_PATH/completion.bash.inc" ]; then . "$GOOGLE_CLOUD_SDK_PATH/completion.bash.inc"; fi
