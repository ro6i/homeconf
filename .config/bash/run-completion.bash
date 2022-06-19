#!/bin/bash

_complit_help() {
  # line 2 is expected to contain the completion spec
  HELP="$(cat "${RUN_CLI_DIR}/run-${COMP_WORDS[1]}.sh" | head -n 2 | tail -1)"
  COMPREPLY=("${HELP}" '')
}

function _one {
  local mode="$1"
  local index="$2"
  local val="${COMP_WORDS[$index]}"
  local var="$3"
  local type="$4"

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
    uuid)
      LOOKUP_TYPES[$index]='uuid'
      LOOKUP_VALUES[$index]=
      ;;
    date)
      LOOKUP_TYPES[$index]='date'
      LOOKUP_VALUES[$index]='YYYY-MM-DD'
      ;;
    text)
      LOOKUP_TYPES[$index]='text'
      LOOKUP_VALUES[$index]=
      ;;
    regex)
      LOOKUP_TYPES[$index]='regex'
      LOOKUP_VALUES[$index]=
      ;;
    integer)
      LOOKUP_TYPES[$index]='integer'
      LOOKUP_VALUES[$index]=
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
  # echo "${COMP_CWORD} -> ${!LOOKUP_TYPES[@]} -> ${#LOOKUP_TYPES[@]}"

  max_key=-1; for k in "${!LOOKUP_TYPES[@]}"; do (($k > max_key)) && max_key=$k; done
  if [[ ${COMP_CWORD} -gt $(($max_key + 1)) ]]; then return; fi

  MATCHED=

  key=$(($COMP_CWORD - 1))

  case "${LOOKUP_TYPES[key]}" in
    from)
      # echo "from - ${LOOKUP_VALUES[key]}; "
      IFS=$'\n' COMPREPLY=($(compgen -W "$(cat "${RUN_CLI_DIR}/${LOOKUP_VALUES[key]}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    opts)
      # echo "opts - ${LOOKUP_VALUES[key]}; "

      split_into_lines="$(echo "${LOOKUP_VALUES[key]}" | sed 's/,/\n/g')"
      IFS=$'\n' opts_split=($(echo "$split_into_lines"))

      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "${opts_split[@]}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
      ;;
    date)
      COMPREPLY=("${LOOKUP_VALUES[key]}")
      ;;
    integer)
      COMPREPLY=('0123')
      ;;
    *)
      ;;
  esac
}

_run_completions() {

  # if the current word is a question mark '?'
  # then the HELP line (second line in the file) is printed
  if [ "${COMP_WORDS[$COMP_CWORD]}" == '?' ]
  then
    _complit_help
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
      # include script that may contain customizations, functions, settings
      GLOBAL_ENV_PATH="$RUN_CLI_DIR/.env.sh"
      [[ -f "$GLOBAL_ENV_PATH" ]] && . "$GLOBAL_ENV_PATH"

      # include the actual runnable script
      # lib functions (e.g. assert, optin) can be invoked inside run script
      . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

      _complit2
    fi
    return
  fi

}

complete -o nosort -F _run_completions run
