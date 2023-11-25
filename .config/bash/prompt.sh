
[[ -z "$PROJECTS_DIR" ]] && PROJECTS_DIR='~/projects'
_component_delimiter=': '

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

_prompt_conf_value() {
  local _name="PROMPT_CONF_${1^^}"
  echo "${!_name}"
}

_prompt_path() {
  local _dir="$(dirs)"
  local _dirname="$(dirname "$_dir")"
  local _compacting_expr
  if [[ ${#_dirname} -gt $(( $(tput cols) / 4 )) && "${_dirname::10}" == "$PROJECTS_DIR" ]]; then
    _compacting_expr="s/\([\/_.-]\)\([a-zA-Z]\)[a-zA-Z][[:alpha:]]*/\1$(tput setaf 59)\2$(tput sgr0)/g;"
  fi
  local _separator_expr="s/\//$(tput setaf 0)\/$(tput setaf 15)/g;"
  local _dirpath="$(tput setaf 7)${_dirname:0:1}$(tput setaf 15)$(echo "${_dirname:1}" | sed "$_compacting_expr $_separator_expr")"
  if [[ "${#_dir}" == 1 ]]
  then
    echo -e "$(tput setaf 7)$_dir$(tput sgr0)"
  else
    local _decorated_base_name="$(tput setaf 7)$(basename "$_dir")"
    if [[ -f ./.dirlabel ]]; then
      _decorated_base_name="$(tput setaf 13)$(cat ./.dirlabel)"
    fi
    echo -e "$_dirpath$(tput setaf 8)/$_decorated_base_name$(tput sgr0)"
  fi
}

PROMPT_TIME_FORMAT='%m-%d %H:%M'

_prompt_time() {
  case "$(_prompt_conf_value time)" in
    on) echo -e " $(tput setaf 8)$(date +"$PROMPT_TIME_FORMAT")$(tput sgr0)" ;;
  esac
}

_prompt_jobs() {
  local _jobs="$(($(jobs -p | wc -l)))"
  if [[ $_jobs -gt 0 ]]
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
        [[ "$value" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]] && value="${value:0:8}" #..${value: -2}"
        printf "$(_component '' "$(tput setaf 236)[$(tput setaf 15)$envVarId $(tput setaf $((9 + $prefixed)))$(tput setb 0)${value}$(tput sgr0)$(tput setaf 238)]$(tput sgr0)")"
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
