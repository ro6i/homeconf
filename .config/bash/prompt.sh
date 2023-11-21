
_component_delimiter=' '

_component() {
  local _marker="$1"
  local _value="$2"
  if [[ ! -z "$_value" ]];
  then
    local _delimiter
    [[ ! -z "$1" ]] && _delimiter="$_component_delimiter"
    echo " $(tput setaf 15)$1$(tput setaf 8)${_delimiter}$_value$(tput sgr0)"
  fi
}

_parse_git_status() {
  local _status=$(git status --short 2> /dev/null | head)
  if [[ ! -z "$_status" ]]
  then
    local _traits=()
    if [[ ! -z "$(git diff --exit-code)" ]]; then _traits+=" $(tput setaf 1)unstaged"; fi
    if [[ ! -z "$(git ls-files --other --exclude-standard --directory --no-empty-directory)" ]]; then _traits+=" $(tput setaf 9)untracked"; fi
    if [[ ! -z "$(git diff --cached --exit-code)" ]]; then _traits+=" $(tput setaf 2)staged"; fi
    _status="${_traits[@]}"
    _status="${_status:1}"
    _status="$(tput setaf 15)($_status$(tput setaf 15))"
  fi
  echo "$_status"
}

_prompt_conf_value() {
  _name="PROMPT_CONF_${1^^}"
  echo "${!_name}"
}

_prompt_component_git() {
  local status_color=37
  local branch_name="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//')"
  if [[ ! -z "$branch_name" ]]
  then
    local branch_prefix_color
    case "${branch_name:0:4}" in
      fix/) branch_prefix_color=1 ;;
      feat) branch_prefix_color=13 ;;
      main) branch_prefix_color=3 ;;
      mast) branch_prefix_color=3 ;;
      deve) branch_prefix_color=2 ;;
      *)    branch_prefix_color=7 ;;
    esac
    local branch="$(echo "$branch_name" | sed "\
      s/\([0-9]\+\)/$(tput setaf 14)\1$(tput sgr0)/1;\
      s/[-]/$(tput setaf 15)-$(tput sgr0)/g;\
      s/^\([a-z]\+\)/$(tput setaf "$branch_prefix_color")\1$(tput sgr0)/;\
      s/[/]\([A-Z]\+\)/$(tput setaf 5)\/$(tput setaf 12)\1$(tput sgr0)/;")"

    local status="$(_parse_git_status)"
    local status_color=$([[ -z $status ]] && echo 7 || echo 3)

    echo -e "$(_component ' git' "$(tput setaf $status_color)$branch$status$(tput sgr0)")"
  fi
}

_prompt_path() {
  local _dir="$(dirs)"
  local _separator="$(tput setaf 8)\/$(tput setaf 15)"
  local _dirname="$(dirname "$_dir")"
  local _dirpath="$(tput setaf 7)${_dirname:0:1}$(tput setaf 15)$(echo "${_dirname:1}" | sed "s/\//$_separator/g")"
  if [[ "$_dir" == '~' || "$_dir" == '/' ]];
  then
    echo -e "$(tput setaf 7)$_dir$(tput sgr0)"
  else
    local _decorated_base_name="$(tput setaf 7)$(basename "$_dir")"
    if [[ -f './.dirlabel' ]]
    then
      _decorated_base_name="$(tput setaf 3)$(tput setaf 11)$(cat './.dirlabel')"
    fi
    echo -e "$_dirpath$(tput setaf 8)/$_decorated_base_name$(tput sgr0)"
  fi
}

PROMPT_TIME_FORMAT='%m-%d %H:%M'

_prompt_time() {
  case "$(_prompt_conf_value time)" in
    on) echo -e " $(tput setaf 8)$(date +"${PROMPT_TIME_FORMAT}")$(tput sgr0)" ;;
  esac
}

_prompt_jobs() {
  local _jobs="$(($(jobs -p | wc -l)))"
  if [[ $_jobs > 0 ]]
  then
    echo -e "$(_component ' jobs' "$(tput setaf 9)$_jobs")"
  fi
}

_prompt_hb() {
  local _time=" $(date +"${PROMPT_TIME_FORMAT}")"
  local _session_width=$(tput cols)
  local _width=$(( 80 < $_session_width ? 80 : $_session_width ))
  local _length=$(( $_width - ${#_time} ))
  echo "$(tput setaf 8)$(printf "%${_length}s" | tr ' ' '-')$(_prompt_time)$(tput sgr0)"
}

_prompt_component_env() {
  local prefixed=0
  env | grep 'PROMPT_CONF_ENV_' | sed 's/=.*//' | sed 's/^PROMPT_CONF_ENV_//' | sort | while read -r envVarId
    do
      [[ $prefixed == 0 ]] && printf '\n'
      if [[ "$(_prompt_conf_value ENV_$envVarId)" == 'on' ]]
      then
        prefixed=$((prefixed + 1))
        local value="${!envVarId}"
        [[ "$value" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]] && value="${value:0:8}..${value: -2}"
        printf "$(_component '' "$(tput setaf 0)[$(tput setaf 15)$envVarId $(tput setaf $((9 + $prefixed)))$(tput setb 0)${value}$(tput sgr0)$(tput setaf 0)]$(tput sgr0)")"
      fi
    done
}

# prompt configuration cli
prompt() {
  local _name="PROMPT_CONF_${2^^}"
  local _val="${!_name}"
  case "$1" in
  toggle)
    case "$_val" in
      on) unset $_name ;;
      *)  export $_name=on ;;
    esac
    ;;
  on)  export $_name=on ;;
  off) unset  $_name ;;
  *) ;;
  esac
}
