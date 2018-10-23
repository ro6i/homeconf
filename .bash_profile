# source .bashrc
list=(
  "/usr/local/etc/bash_completion.d/brew"
  "/usr/local/etc/bash_completion.d/git-completion.bash"
  "/usr/local/etc/bash_completion.d/git-prompt.sh"
  "/usr/local/etc/bash_completion.d/tmux"
  "/usr/local/etc/bash_completion.d/scala"
  "/usr/local/etc/bash_completion.d/npm.sh"
  "${HOME}/.config/bash/.bashrc_prompt"
  "${HOME}/.config/bash/.bashrc"
)

for item in ${list[*]}
do
  [ -r "${item}" ] && source "${item}"
done
