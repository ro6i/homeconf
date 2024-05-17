#!/bin/bash

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
  local dir_path="$(tput setaf 7)${_dirname:0:1}$(tput setaf 15)$(echo "${_dirname:1}")"
  if [[ "${#_dir}" == 1 ]]
  then
    echo -e "$(tput setab 32)$(tput setaf 7)$_dir\033[K$(tput sgr0)"
  else
    local decorated_base_name="$(tput setaf 7)$(basename "$_dir")"
    echo -e "$(tput setab 32)$dir_path$(tput setaf 15)/$decorated_base_name\033[K$(tput sgr0)"
  fi
}

PROMPT_TIME_FORMAT=

_prompt_time() {
  case "$(_prompt_conf_value time)" in
    yes)
      local current="$(date +'%H:%M:%S %m-%d')"
      echo -e "$(tput setaf 39)[$(tput setaf 8)${current::8}$(tput setaf 39)] $(tput setaf 8)${current:9:5}$(tput sgr0)"
      ;;
  esac
}

_prompt_jobs() {
  local _jobs="$(($(jobs -p | wc -l)))"
  if [[ $_jobs -gt 0 ]]
  then
    echo -e "$(__prompt_component " $(tput setaf 15)jobs$(tput setaf 8): $(tput setaf 9)$_jobs")"
  fi
}

_prompt_hb() {
  case "$?" in
    0) ;;
    *) >&2 printf "$(tput setab $?)$(tput setaf 11) $(tput sgr0) " ;;
  esac
  >&2 echo -e "$(_prompt_time)$(tput sgr0)"
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
      printf "$(__prompt_component " $(tput setaf 8)[$(tput setaf 15)$_name$separator$(tput setaf $((9 + $__prompt_env_counter)))$(tput setb 0)$value$(tput sgr0)$(tput setaf 8)]$(tput sgr0)")"
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
