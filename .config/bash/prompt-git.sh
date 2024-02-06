__parse_git_status() {
  local _status=$(git status --short 2> /dev/null | head -n 1)
  if [[ ! -z "$_status" ]]
  then
    local unstaged_count="$(git diff --numstat | wc -l)" #"$(git diff --exit-code)"
    local untracked_count="$(git ls-files --other --exclude-standard --directory --no-empty-directory | wc -l)"
    local staged_count="$(git diff --cached --numstat | wc -l)"
    if [[ "$unstaged_count" -gt 0 || "$untracked_count" -gt 0 || "$staged_count" -gt 0 ]]
    then
      [[ "$staged_count"    -eq 0 ]] && staged='--'    || staged="$staged_count"
      [[ "$unstaged_count"  -eq 0 ]] && unstaged='--'  || unstaged="$unstaged_count"
      [[ "$untracked_count" -eq 0 ]] && untracked='--' || untracked="$untracked_count"
      echo -e "$(tput setaf 238)($(tput setaf 2)$staged$(tput setaf 8):$(tput setaf 1)$unstaged$(tput setaf 8):$(tput setaf 9)$untracked$(tput setaf 238))"
    fi
  fi
}

_prompt_component_git() {
  local branch_name="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//')"
  [[ -z "$branch_name" ]] && return 0
  local prefix_color branch status_color status scope scope_num
  if [[ "${branch_name:0:1}" =~ [a-zA-Z0-9] ]]
  then
    if [[ ! "$branch_name" =~ / ]]
    then
      case "$branch_name" in
        main|master) prefix_color=3 ;;
        develop)     prefix_color=2 ;;
        *)           prefix_color=5 ;;
      esac
      branch="$(tput setaf "$prefix_color")$branch_name$(tput sgr0)"
    else
      local prefix="${branch_name%%/*}"
      branch_name="$(echo "$branch_name" | cut -c $(( ${#prefix} + 2))-)"
      case "$prefix" in
        fix)     prefix_color=1 ;;
        feat)    prefix_color=13 ;;
        feature) prefix_color=13 ;;
        release) prefix_color=10 ;;
        *)       prefix_color=7 ;;
      esac
      if [[ "$branch_name" =~ ^[A-Z]+[-] ]]
      then
        scope="${branch_name%%-*}"
        branch_name="$(echo "$branch_name" | cut -c $(( ${#scope} + 2))-)"
      fi
      if [[ "$branch_name" =~ ^[0-9]+[-] ]]
      then
        scope_num="${branch_name%%-*}"
        branch_name="$(echo "$branch_name" | cut -c $(( ${#scope_num} + 1))-)"
      fi

      branch="$(tput setaf "$prefix_color")$prefix$(tput setaf 5)/$(tput setaf 12)$scope$(tput setaf 5)-$(tput setaf 14)$scope_num$(tput sgr0)$(tput setaf 7)$branch_name"
    fi
    status_color=7
  else
    branch="$branch_name"
    status_color=5
  fi

  status="$(__parse_git_status)"
  echo -e "$(_component ' git' "$(tput setaf $status_color)$branch$status$(tput sgr0)")"
}
