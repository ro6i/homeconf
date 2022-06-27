#!/bin/bash

function _one {
  local mode="$1"
  local index="$2"
  local val="${COMP_WORDS[$(($index + 1))]}"
  local var="$3"
  local type="$4"

  LOOKUP_VARS[$index]="$var"
  CURRENT_VALS[$index]="$val"

  case "$type" in
    from)
      LOOKUP_TYPES[$index]='from'
      LOOKUP_VALUES[$index]="$5"
      ;;
    opts)
      _arg_list=(${@:5})
      LOOKUP_TYPES[$index]='opts'
      LOOKUP_VALUES[$index]=$(IFS=, ; echo "${_arg_list[*]}")
      ;;
    shell)
      RUN_SHELL_ARGS=(${COMP_WORDS[@]:1})
      LOOKUP_TYPES[$index]='shell'
      LOOKUP_VALUES[$index]="$5"
      ;;
    command)
      LOOKUP_TYPES[$index]='command'
      LOOKUP_VALUES[$index]="$5"
      ;;
    uuid)
      LOOKUP_TYPES[$index]='uuid'
      LOOKUP_VALUES[$index]="[UUID]"
      ;;
    date)
      LOOKUP_TYPES[$index]='date'
      LOOKUP_VALUES[$index]='[YYYY-MM-DD]'
      ;;
    text)
      LOOKUP_TYPES[$index]='text'
      LOOKUP_VALUES[$index]='[TEXT]'
      ;;
    regex)
      LOOKUP_TYPES[$index]='regex'
      LOOKUP_VALUES[$index]='[REGEX"]'
      ;;
    integer)
      LOOKUP_TYPES[$index]='integer'
      LOOKUP_VALUES[$index]='[INTEGER]'
      ;;
    *)
      ;;
  esac

}

# high level interface
function assert {
  _one assert "$@"
}

function optin {
  _one optin "$@"
}


_complit2() {
  # if available argument completion is exhausted
  # then ignore the completion request

  max_key=-1; for k in "${!LOOKUP_TYPES[@]}"; do (($k > max_key)) && max_key=$k; done
  if [[ ${COMP_CWORD} -gt $(($max_key + 1)) ]]; then return; fi

  MATCHED=

  key=$(($COMP_CWORD - 1))

  case "${LOOKUP_TYPES[key]}" in
    from)
      IFS=$'\n' COMPREPLY=($(compgen -W "$(cat "${RUN_CLI_DIR}/${LOOKUP_VALUES[key]}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    opts)
      split_into_lines="$(echo "${LOOKUP_VALUES[key]}" | sed 's/,/\n/g')"
      IFS=$'\n' opts_split=($(echo "$split_into_lines"))

      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "${opts_split[@]}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    shell)
      shell_code="${LOOKUP_VALUES[key]}"
      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "$(eval "$shell_code")")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    command)
      IFS=' ' command_line="${LOOKUP_VALUES[key]} ${COMP_WORDS[*]:2}"
      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "$(eval "$command_line")")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    uuid)
      IFS=$'\n' COMPREPLY=($(compgen -W "${LOOKUP_VALUES[key]}" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    date)
      IFS=$'\n' COMPREPLY=($(compgen -W "${LOOKUP_VALUES[key]}" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    text)
      IFS=$'\n' COMPREPLY=($(compgen -W "${LOOKUP_VALUES[key]}" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    integer)
      IFS=$'\n' COMPREPLY=($(compgen -W "${LOOKUP_VALUES[key]}" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    *)
      ;;
  esac
}

_complit2_help() {
  local max_key=-1; for k in "${!LOOKUP_VARS[@]}"; do (($k > max_key)) && max_key=$k; done
  local help_spec=''
  local param=''

  for key in $(seq 1 $max_key)
  do
    if [[ -z ${LOOKUP_VARS[key]} ]]
    then
      param='_'
    else
      param="${LOOKUP_VARS[key]}"
    fi
    help_spec="$help_spec  [${key}:${param}]"
  done
  COMPREPLY=("usage:$help_spec" '')
}

_complit2_inspect() {
  local max_key=-1; for k in "${!LOOKUP_VARS[@]}"; do (($k > max_key)) && max_key=$k; done
  local help_spec=''
  local param=''
  local val=

  printf '\nusage (current):'

  for key in $(seq 1 $max_key)
  do
    if [[ -z ${LOOKUP_VARS[key]} ]]
    then
      param="_"
    else
      param="${LOOKUP_VARS[key]}"
    fi
    if [[ $key -le $(($COMP_CWORD - 2)) ]]
    then
      val="${CURRENT_VALS[key]}"
    else
      val=
    fi

    local field="${key}:${param}"
    printf '\n  %s%*s = %s' "$field" "$((20-${#field}))" '' "$val"
  done
  COMPREPLY=('')
}

_run_completions() {

  declare -a LOOKUP_VARS
  declare -a LOOKUP_TYPES
  declare -a LOOKUP_VALUES
  declare -a CURRENT_VALS

  if [ "${COMP_CWORD}" -gt 1 ] && [ ! -f "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh" ]
  then
    COMPREPLY=('' '')
    return
  fi

  if [[ "${COMP_WORDS[$COMP_CWORD]}" == '?' ]]
  then
    # include the actual runnable script
    # lib functions (e.g. assert, optin) can be invoked inside run script
    . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

    _complit2_help
    return
  fi
  if [[ "${COMP_WORDS[$COMP_CWORD]}" == '??' && $COMP_TYPE == 63 ]]
  then
    # include the actual runnable script
    # lib functions (e.g. assert, optin) can be invoked inside run script
    . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

    _complit2_inspect
    return
  fi

  # the first section is completed with script names at the RUN_CLI_DIR
  # in order to be listed the script file name must start with 'run-'
  if [ "${COMP_CWORD}" -eq 1 ]
  then
    IFS=$'\n'
    COMPREPLY=($(compgen -W "$(find "${RUN_CLI_DIR}" -type f -name 'run-*' -printf "%f\n" | sed 's/^run-//g; s/.sh$//g'| sort)" -- "${COMP_WORDS[1]}"))
    return
  else
    if [ "${COMP_CWORD}" -gt 1 ]
    then
      # include the actual runnable script
      # lib functions (e.g. assert, optin) can be invoked inside run script
      . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

      _complit2
    fi
    return
  fi

}

complete -o nosort -F _run_completions run
