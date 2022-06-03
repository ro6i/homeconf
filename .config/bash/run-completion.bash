#!/bin/bash

_complit_help() {
  # line 2 is expected to contain the completion spec
  HELP="$(cat "${RUN_CLI_DIR}/run-${COMP_WORDS[1]}.sh" | head -n 2 | tail -1)"
  COMPREPLY=("${HELP}" '')
}

# argument completion
# parameter specifications are separated by ;;
_complit() {
  CONF_LINE_1="$1"

  S1="$(echo "$CONF_LINE_1" | sed 's/;;/\n/g')"
  IFS=$'\n' SPLIT=( $(echo "$S1") )

  # if available argument completion is exhausted
  # then ignore the completion request
  if [[ "${COMP_CWORD}" -gt $((${#SPLIT[@]} + 1)) ]]
  then
    return
  fi

  MATCHED=
  for i in "${!SPLIT[@]}"
  do
    LINE="$(echo "${SPLIT[i]}" | awk '{$1=$1};1')"
    # if the specification is like
    # <NAME> @ <path/to/file>
    # then the file content is used for completion
    if [[ "$LINE" =~ ^[A-Z][A-Z0-9]*[[:space:]][@][[:space:]].* ]]
    then
      if [[ "${COMP_CWORD}" -eq $((i + 2)) ]]
      then
        IFS='@'; read -a PARTS <<< "$LINE"
        PART_RIGHT=$(echo ${PARTS[1]} | awk '{$1=$1};1')
        IFS=$'\n'
        COMPREPLY=($(compgen -W "$(cat "${RUN_CLI_DIR}/$PART_RIGHT")" -- "${COMP_WORDS[$COMP_CWORD]}"))
        MATCHED=yes
        break
      fi
    else
      # if no section syntax is matched
      # then the parameter specificaton is printed
      if [[ ! -z "${SPLIT[i]}" ]]
      then
        COMPREPLY=("  SPEC: $LINE" '')
      else
        return
      fi
    fi

    if [[ $MATCHED -ne 'yes' ]]
    then
      _complit_help
    fi

  done
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
      # line 3 is expected to contain the argument completion spec
      SPEC="$(cat "${RUN_CLI_DIR}/run-${COMP_WORDS[1]}.sh" | sed 's/^[#][[:space:]]*//' | head -n 3 | tail -1)"

      _complit "$SPEC"
    fi
    return
  fi

}

complete -o nosort -F _run_completions run
