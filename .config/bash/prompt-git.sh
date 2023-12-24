__parse_git_status() {
  local _status=$(git status --short 2> /dev/null | head)
  if [[ ! -z "$_status" ]]
  then
    local _traits=()
    [[ ! -z "$(git diff --exit-code)" ]] && _traits+=" $(tput setaf 1)unstaged"
    [[ ! -z "$(git ls-files --other --exclude-standard --directory --no-empty-directory)" ]] && _traits+=" $(tput setaf 9)untracked"
    [[ ! -z "$(git diff --cached --exit-code)" ]] && _traits+=" $(tput setaf 2)staged"
    _status="${_traits[@]}"
    _status="${_status:1}"
    _status="$(tput setaf 15)($_status$(tput setaf 15))"
  fi
  echo "$_status"
}

_prompt_component_git() {
  local branch_name="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//')"
  [[ -z "$branch_name" ]] && return 0
  local branch_prefix_color
  local branch
  if [[ "${branch_name:0:1}" =~ [a-zA-Z0-9] ]];
  then
    case "${branch_name%%/*}" in
      fix)     branch_prefix_color=1 ;;
      feat)    branch_prefix_color=13 ;;
      feature) branch_prefix_color=13 ;;
      main)    branch_prefix_color=3 ;;
      master)  branch_prefix_color=3 ;;
      develop) branch_prefix_color=2 ;;
      release) branch_prefix_color=10 ;;
      *)       branch_prefix_color=7 ;;
    esac
    branch="$(echo "$branch_name" | sed "\
      s/\([0-9]\+\)/$(tput setaf 14)\1$(tput sgr0)/1;\
      s/[-]/$(tput setaf 15)-$(tput sgr0)/g;\
      s/^\([a-z]\+\)/$(tput setaf "$branch_prefix_color")\1$(tput sgr0)/;\
      s/[/]\([A-Z]\+\)/$(tput setaf 5)\/$(tput setaf 12)\1$(tput sgr0)/;")"
  else
    branch="$branch_name"
  fi

  local status="$(__parse_git_status)"
  local status_color=7
  [[ -z "$status" ]] && status_color=3

  echo -e "$(_component ' git' "$(tput setaf $status_color)$branch$status$(tput sgr0)")"
}
