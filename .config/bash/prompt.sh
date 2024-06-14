#!/bin/bash

__prompt_component() {
  local value="$1"
  if [[ ! -z "$value" ]]
  then
    echo "$value$(tput sgr0)"
  fi
}

_prompt_path() {
  local _dir="$(dirs)"
  local _dirname="$(dirname "$_dir")"
  local dir_path="$(tput setaf 7)${_dirname:0:1}$(tput setaf 8)$(echo "${_dirname:1}")"
  if [[ "${#_dir}" == 1 ]]
  then
    echo -e "$(tput setab 16)$(tput setaf 7)$_dir\033[K$(tput sgr0)"
  else
    local decorated_base_name="$(tput setaf 7)$(basename "$_dir")"
    echo -e "$(tput setab 16)$dir_path$(tput setaf 15)/$decorated_base_name\033[K$(tput sgr0)"
  fi
}

_prompt_time() {
  local current="$(date +'%H:%M:%S %m-%d')"
  echo -e "$(tput setaf 24)[$(tput setaf 24)${current::8}$(tput setaf 24)] $(tput setaf 24)${current:9:5}$(tput sgr0)"
}

_prompt_jobs() {
  local _jobs="$(($(jobs -p | wc -l)))"
  if [[ $_jobs -gt 0 ]]
  then
    echo -e "$(__prompt_component " $(tput setaf 8)jobs$(tput setaf 31): $(tput setaf 9)$_jobs")"
  fi
}

_prompt_hb() {
  case "$?" in
    0) ;;
    *) >&2 printf "$(tput setab $?)$(tput setaf 3) $(tput sgr0) " ;;
  esac
  >&2 echo -e "$(_prompt_time)$(tput sgr0)"
}
