[[ -z "$PROJECTS_DIR" ]] && PROJECTS_DIR='~/projects'

__prompt_component() {
  local value="$1"
  if [[ ! -z "$value" ]]
  then
    echo "$value$(tput sgr0)"
  fi
}

_prompt_conf_value() {
  local _name="PROMPT_CONF_${1^^}"
  echo "${!_name}"
}

_prompt_path() {
  local _dir="$(dirs)"
  local _dirname="$(dirname "$_dir")"
  local compacting_expr
  if [[ ${#_dir} -gt $(( $(tput cols) - 10 )) && "${_dirname::10}" == "$PROJECTS_DIR" ]]
  then
    compacting_expr="s/\([\/_.-]\)\([a-zA-Z]\{1,2\}\)[[:alpha:]]*/\1$(tput setaf 240)\2 /g;"
  fi
  local separator_expr="s/\//$(tput setaf 8)\/$(tput setaf 240)/g;"
  local dir_path="$(tput setaf 7)${_dirname:0:1}$(tput setaf 15)$(echo "${_dirname:1}" | sed "$compacting_expr $separator_expr")"
  if [[ "${#_dir}" == 1 ]]
  then
    echo -e "$(tput setab 234)$(tput setaf 7)$_dir$(tput sgr0)"
  else
    local decorated_base_name="$(tput setaf 242)$(basename "$_dir")"
    if [[ -f ./.dirlabel ]]
    then
      decorated_base_name="$(tput setaf 13)$(cat ./.dirlabel)"
    fi
    echo -e "$(tput setab 234)$dir_path$(tput setaf 8)/$decorated_base_name$(tput sgr0)"
  fi
}

PROMPT_TIME_FORMAT=

_prompt_time() {
  case "$(_prompt_conf_value time)" in
    yes)
      local current="$(date +'%H:%M:%S %m-%d')"
      echo -e "$(tput setaf 235)[$(tput setaf 236)${current::8}$(tput setaf 235)] $(tput setaf 236)${current:9:5}$(tput sgr0)"
      ;;
  esac
}

_prompt_jobs() {
  local _jobs="$(($(jobs -p | wc -l)))"
  if [[ $_jobs -gt 0 ]]
  then
    echo -e "$(__prompt_component " $(tput setaf 238)jobs$(tput setaf 8): $(tput setaf 9)$_jobs")"
  fi
}

_prompt_hb() {
  case "$?" in 
    0)   last_status_color=22 ;;
    130|141) last_status_color=94 ;;
    *)   last_status_color=88 ;;
  esac

  # local _session_width
  # if [[ "$TERM_PROGRAM" == 'tmux' ]]
  # then
  #   _session_width=$(tmux display-message -p '#{window_width}' 2> /dev/null)
  # else
  #   _session_width="$(tput cols)"
  # fi
  # local _width=$(( $_session_width < 128 ? 128 : $_session_width ))
  # local _length=$(( $_width / 2 - 16 - 1 ))
  # echo "$(tput setaf 0)$(printf "%${_length}s" | tr ' ' ' ')$(_prompt_time)$(tput sgr0)"
  echo -e "$(tput setaf "$last_status_color")■$(tput sgr0) $(_prompt_time)$(tput sgr0)"
}

__prompt_env_by_tag() {
  export __prompt_env_counter=0
  env | grep 'PROMPT_ENV__' | grep ":$tag:" | sort -t ':' -k3 | sed 's/=.*//' | sed 's/^PROMPT_ENV__//' | while read -r envVarId
    do
      local keyName="PROMPT_ENV__$envVarId" separator
      IFS=':' read -r _name _tag _sort <<<"${!keyName}"
      local value="${!envVarId}"
      [[ "$value" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]] && value="${value:0:8}" #..${value: -2}"

      [[ -z "$_name" ]] || separator=' '
      __prompt_env_counter="$((1 + $__prompt_env_counter))"
      [[ "$__prompt_env_counter" -eq 1 ]] && printf '\n'
      printf "$(__prompt_component " $(tput setaf 235)[$(tput setaf 15)$_name$separator$(tput setaf $((9 + $__prompt_env_counter)))$(tput setb 0)$value$(tput sgr0)$(tput setaf 235)]$(tput sgr0)")"
    done
}

_prompt_env() {
  env | grep 'PROMPT_ENV__' | awk -F':' '{print $2}' | sort | uniq | while read -r tag
    do
      __prompt_env_by_tag "$tag"
    done
}

# prompt configuration cli
prompt() {
  local _name="PROMPT_CONF_${2^^}"
  local _val="${!_name}"
  case "$1" in
  toggle)
    case "$_val" in
      yes) unset $_name ;;
      *)  export $_name=on ;;
    esac
    ;;
  yes)  export $_name=on ;;
  no) unset  $_name ;;
  *) ;;
  esac
}
