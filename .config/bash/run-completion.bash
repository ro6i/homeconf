#!/bin/bash

_run_completions() {

  if [ "${#COMP_WORDS[@]}" == "3" ]; then
    HELP="$(cat "${RUN_PATH}/run-${COMP_WORDS[1]}.sh" | head -n 2 | tail -1)"
    COMPREPLY=("${HELP}" '')
  fi

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  COMPREPLY=($(compgen -W "$(find "${RUN_PATH}" -type f -name 'run-*' -printf "%f\n" | sed 's/^run-//g; s/.sh$//g')" -- "${COMP_WORDS[1]}"))
}

complete -o nosort -F _run_completions run
