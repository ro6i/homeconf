#!/bin/bash

function _update_index {
  case "$1" in
    _)
      if [[ ! -v OPTIONAL_ARG_VARS[$2] ]]
      then
        OPTIONAL_PARAM_COUNT=$(($OPTIONAL_PARAM_COUNT + 1))
        OPTIONAL_ARG_VARS["$2"]="$2"
      fi
      ;;
    *)
      if (($POSITIONAL_PARAM_COUNT < $1))
      then
        POSITIONAL_PARAM_COUNT=$1
      fi
      POSITIONAL_ARG_VARS[$index]="$var"
      ;;
  esac
}

function _one {
  local index="$1"
  local var="$2"
  local type="$3"

  _update_index "$index" "$var"

  if [[ "$index" == '_' ]]; then index="$var"; fi

  case "$type" in
    from)
      LOOKUP_TYPES["$index"]='from'
      LOOKUP_VALUES["$index"]="$4"
      ;;
    opts)
      _arg_list=(${@:4})
      LOOKUP_TYPES["$index"]='opts'
      LOOKUP_VALUES["$index"]=$(IFS=, ; echo "${_arg_list[*]}")
      ;;
    shell)
      RUN_SHELL_ARGS=(${COMP_WORDS[@]:1})
      LOOKUP_TYPES["$index"]='shell'
      LOOKUP_VALUES["$index"]="$4"
      ;;
    command)
      LOOKUP_TYPES["$index"]='command'
      LOOKUP_VALUES["$index"]="$4"
      ;;
    uuid)
      LOOKUP_TYPES["$index"]='uuid'
      LOOKUP_VALUES["$index"]="[UUID]"
      ;;
    date)
      LOOKUP_TYPES["$index"]='date'
      LOOKUP_VALUES["$index"]='[YYYY-MM-DD]'
      ;;
    text)
      LOOKUP_TYPES["$index"]='text'
      LOOKUP_VALUES["$index"]='[TEXT]'
      ;;
    regex)
      LOOKUP_TYPES["$index"]='regex'
      LOOKUP_VALUES["$index"]='[REGEX"]'
      ;;
    integer)
      LOOKUP_TYPES["$index"]='integer'
      LOOKUP_VALUES["$index"]='[INTEGER]'
      ;;
    *)
      ;;
  esac

}

# high level interface
function assert {
  _one "$@"
}

function param {
  _one "$@"
}

function at {
  _one "$@"
}

_complit2() {
  # if available argument completion is exhausted
  # then ignore the completion request

  # optionals consist of three parts and are specifired like <param>:<value>
  if [[ ${COMP_CWORD} -gt $(($POSITIONAL_PARAM_COUNT + $OPTIONAL_PARAM_COUNT * 3 + 1)) ]]; then return; fi

  local sector=POSITIONAL
  if (( $POSITIONAL_PARAM_COUNT > 0 && ${COMP_CWORD} > $POSITIONAL_PARAM_COUNT + 1))
  then
    sector=OPTIONAL
  fi

  local key=
  local key_shift=0
  case $sector in
    POSITIONAL)
      key="$(($COMP_CWORD - 1))"
      ;;
    OPTIONAL)
      if [[ "${COMP_WORDS[$COMP_CWORD]}" == ':' ]]
      then
        key="${COMP_WORDS[$(($COMP_CWORD - 1))]}"
        key_shift=1
        if [[ -z "$key" || ! -v OPTIONAL_ARG_VARS[$key] ]]; then return; fi
      elif [[ "${COMP_WORDS[$(($COMP_CWORD - 1))]}" == ':' ]]
      then
        key="${COMP_WORDS[$(($COMP_CWORD - 2))]}"
        key_shift=0
        if [[ -z "$key" || ! -v OPTIONAL_ARG_VARS[$key] ]]; then return; fi
      else
        COMPREPLY=($(compgen -W "$(printf "%s\n" "${OPTIONAL_ARG_VARS[@]/%/:}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
        return
      fi
      ;;
  esac

  local word_index=$(($COMP_CWORD + $key_shift))

  # echo "==> POSITIONAL_PARAM_COUNT=$POSITIONAL_PARAM_COUNT ; OPTIONAL_PARAM_COUNT=$OPTIONAL_PARAM_COUNT ; LOOKUP_TYPES=$!LOOKUP_TYPES[@]} ; key=$key ; LOOKUP_TYPES[key]=${LOOKUP_TYPES[$key]} ; POSITIONAL_ARG_VARS=[${POSITIONAL_ARG_VARS[@]}]" >> ~/projects/endowus/run/run-completion.bash.log

  case "${LOOKUP_TYPES[$key]}" in
    from)
      IFS=$'\n' COMPREPLY=($(compgen -W "$(cat "${RUN_CLI_DIR}/${LOOKUP_VALUES[$key]}")" -- "${COMP_WORDS[$word_index]}"))
      ;;
    opts)
      split_into_lines="$(echo "${LOOKUP_VALUES[$key]}" | sed 's/,/\n/g')"
      IFS=$'\n' opts_split=($(echo "$split_into_lines"))

      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "${opts_split[@]}")" -- "${COMP_WORDS[$word_index]}"))

      ;;
    shell)
      shell_code="${LOOKUP_VALUES[$key]}"
      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "$(eval "$shell_code")")" -- "${COMP_WORDS[$word_index]}"))
      ;;
    command)
      IFS=' ' command_line="${LOOKUP_VALUES[$key]} ${COMP_WORDS[*]:2}"
      IFS=$'\n' COMPREPLY=($(compgen -W "$(printf "%s\n" "$(eval "$command_line")")" -- "${COMP_WORDS[$word_index]}"))
      ;;
    uuid | date | text | integer)
      IFS=$'\n' COMPREPLY=($(compgen -W "${LOOKUP_VALUES[$key]}" -- "${COMP_WORDS[$word_index]}"))
      ;;
    *)
      ;;
  esac
}

_complit2_help() {
  local help_spec=''

  for key in $(seq 1 $POSITIONAL_PARAM_COUNT)
  do
    help_spec="$help_spec  [$key:${POSITIONAL_ARG_VARS[$key]}]"
  done
  help_spec="$help_spec  (${OPTIONAL_ARG_VARS[@]})"
  COMPREPLY=("usage:$help_spec" '')
}

_complit2_inspect() {
  declare -A arg_map
  local sector=POSITIONAL
  local option_name=

  for index in $(seq 2 "$((${#COMP_WORDS[@]} - 2))")
  do
    local word="${COMP_WORDS[$index]}"
    local word_1="${COMP_WORDS[$(($index + 1))]}"
    local word_2="${COMP_WORDS[$(($index + 2))]}"

    if [[ "$word" == ':' ]]
    then
      continue
    elif [[ "$word" != ':' && "$word_1" == ':' ]]
    then
      sector=OPTIONAL
      if [[ ! -z "$option_name" ]]; then
        return
      fi
      option_name="$word"
    else
      case $sector in
        OPTIONAL)
          if [[ -z "$option_name" ]]; then
            return
          fi
          arg_map["$option_name"]="$word"
          option_name=
          ;;
        POSITIONAL)
          arg_map["$(($index - 1))"]="$word"
          ;;
      esac
    fi
  done
  local help_spec=''

  printf '\nusage (current):'

  for key in $(seq 1 $POSITIONAL_PARAM_COUNT)
  do
    local field="${key}:${POSITIONAL_ARG_VARS[$key]}"
    printf '\n  %s%*s = %s' "$field" "$((20-${#field}))" '' "${arg_map[$key]}"
  done
  for option_name in "${!OPTIONAL_ARG_VARS[@]}"
  do
    printf '\n  %s%*s = %s' "_:$option_name" "$((18-${#option_name}))" '' "${arg_map[$option_name]}"
  done
  COMPREPLY=('')
}

_run_completions() {

  declare -A LOOKUP_TYPES
  declare -A LOOKUP_VALUES
  declare -a POSITIONAL_ARG_VARS
  declare -A OPTIONAL_ARG_VARS
  declare -a CURRENT_VALS

  POSITIONAL_PARAM_COUNT=0
  OPTIONAL_PARAM_COUNT=0
  POSITIONAL_ARG_VARS[0]=
  CURRENT_VALS[0]=

  if [ "${COMP_CWORD}" -gt 1 ] && [ ! -f "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh" ]
  then
    COMPREPLY=('' '')
    return
  fi

  if [[ "${COMP_WORDS[$COMP_CWORD]}" == '?' ]]
  then
    # include the actual runnable script
    . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

    _complit2_help
    return
  elif [[ "${COMP_WORDS[$COMP_CWORD]}" == '??' && $COMP_TYPE == 63 ]]
  then
    # include the actual runnable script
    . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

    _complit2_inspect
    return
  elif [ "${COMP_CWORD}" -eq 1 ]
  then
    # the first section is completed with script names at the RUN_CLI_DIR
    # in order to be listed the script file name must start with 'run-'
    IFS=$'\n'
    COMPREPLY=($(compgen -W "$(find "${RUN_CLI_DIR}" -type f -name 'run-*' -printf "%f\n" | sed 's/^run-//g; s/.sh$//g'| sort)" -- "${COMP_WORDS[1]}"))
    return
  elif [ "${COMP_CWORD}" -gt 1 ]
  then
      # include the actual runnable script
      . "$RUN_CLI_DIR/run-${COMP_WORDS[1]}.sh"

      _complit2
    return
  fi

}

complete -o nosort -F _run_completions run
