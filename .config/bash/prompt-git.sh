__parse_git_status() {
  local _status=$(git status --short 2> /dev/null | head -n 1)
  if [[ ! -z "$_status" ]]
  then
    local unstaged_count="$(git diff --numstat | wc -l)" #"$(git diff --exit-code)"
    local untracked_count="$(git ls-files --other --exclude-standard --directory --no-empty-directory | wc -l)"
    local staged_count="$(git diff --cached --numstat | wc -l)"
    if [[ "$unstaged_count" -gt 0 || "$untracked_count" -gt 0 || "$staged_count" -gt 0 ]]
    then
      [[ "$unstaged_count"  -eq 0 ]] && unstaged='--'  || unstaged=$(printf %02d "$unstaged_count")
      [[ "$untracked_count" -eq 0 ]] && untracked='--' || untracked=$(printf %02d "$untracked_count")
      [[ "$staged_count"    -eq 0 ]] && staged='--'    || staged=$(printf %02d "$staged_count")
      echo -e "$(tput setaf 238)($(tput setaf 3)$unstaged$(tput sgr0):$(tput setaf 9)$untracked$(tput sgr0):$(tput setaf 2)$staged$(tput sgr0)$(tput setaf 238))"
    fi
  fi
}

_prompt_component_git() {
  local branch_name="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//')"
  [[ -z "$branch_name" ]] && return 0
  local branch_prefix_color branch status_color status
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
    status_color=3
  else
    branch="$branch_name"
    status_color=5
  fi

  status="$(__parse_git_status)"
  echo -e "$(_component ' git' "$(tput setaf $status_color)$branch$status$(tput sgr0)")"
}
