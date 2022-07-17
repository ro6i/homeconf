#!/bin/bash

__one()
{
  local index="$1"
  local var="$2"
  local type="$3"

  # update index
  case "$index" in
    _)
      if [[ ! -v OPTIONAL_ARG_VARS[$var] ]]
      then
        OPTIONAL_PARAM_COUNT=$(($OPTIONAL_PARAM_COUNT + 1))
        OPTIONAL_ARG_VARS["$var"]="$var"
      fi
      ;;
    *)
      if (($POSITIONAL_PARAM_COUNT < $index))
      then
        POSITIONAL_PARAM_COUNT=$index
      fi
      POSITIONAL_ARG_VARS[$index]="$var"
      ;;
  esac

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
      LOOKUP_VALUES["$index"]='[REGEX]'
      ;;
    integer)
      LOOKUP_TYPES["$index"]='integer'
      LOOKUP_VALUES["$index"]='[INTEGER]'
      ;;
    _)
      LOOKUP_TYPES["$index"]='_'
      LOOKUP_VALUES["$index"]=
      ;;
    *)
      ;;
  esac

}

__script_name_to_path()
{
  IFS='/' read -r -a __script_name_sections <<< "$1"
  local section_array=("${__script_name_sections[@]/#/_ }")
  printf '/%s' "${section_array[@]}"
}


# high level interface
at() { __one "$@"; }


__complit2()
{
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
    _)
      IFS=$'\n' COMPREPLY=($(compgen -W '_' -- "${COMP_WORDS[$word_index]}"))
      ;;
    *)
      ;;
  esac
}

__complit2_help()
{
  local help_spec=''

  for key in $(seq 1 $POSITIONAL_PARAM_COUNT)
  do
    help_spec="$help_spec  [$key:${POSITIONAL_ARG_VARS[$key]}]"
  done
  local optional_arg_spec="${OPTIONAL_ARG_VARS[@]}"
  help_spec="$help_spec  ${optional_arg_spec:+($optional_arg_spec)}"
  COMPREPLY=("usage:$help_spec" '')
}

__complit2_inspect()
{
  declare -A arg_map
  local sector=POSITIONAL
  local option_name=

  for index in $(seq 2 "$((${#COMP_WORDS[@]} - 2))")
  do
    local word="${COMP_WORDS[$index]}"
    local word_1="${COMP_WORDS[$(($index + 1))]}"

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
          case "$word" in
            _)
              arg_map["$option_name"]=
              ;;
            *)
              arg_map["$option_name"]="$word"
              ;;
          esac
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

_run_completions()
{

  declare -A LOOKUP_TYPES
  declare -A LOOKUP_VALUES
  declare -a POSITIONAL_ARG_VARS
  declare -A OPTIONAL_ARG_VARS
  declare -a CURRENT_VALS

  POSITIONAL_PARAM_COUNT=0
  OPTIONAL_PARAM_COUNT=0
  POSITIONAL_ARG_VARS[0]=
  CURRENT_VALS[0]=

  SCRIPT_PATH="$(__script_name_to_path "${COMP_WORDS[1]}")"

  if [ "${COMP_CWORD}" -gt 1 ] && [ ! -f "$RUN_CLI_DIR/${SCRIPT_PATH}.sh" ]
  then
    COMPREPLY=('' '')
    return
  fi

  if [[ "${COMP_WORDS[$COMP_CWORD]}" == '?' ]]
  then
    # include the actual runnable script
    . "$RUN_CLI_DIR/${SCRIPT_PATH}.sh"

    __complit2_help
    return

  elif [[ "${COMP_WORDS[$COMP_CWORD]}" == '??' && $COMP_TYPE == 63 ]]
  then
    # include the actual runnable script
    . "$RUN_CLI_DIR/${SCRIPT_PATH}.sh"

    __complit2_inspect
    return

  elif [ "${COMP_CWORD}" -eq 1 ]
  then
    # the first section is completed with script names at the RUN_CLI_DIR
    # in order to be listed the script file name must start with '_ '
    # sub-directories are supported and must start with '_ ' as well
    local IFS=$'\n'
    local word="${COMP_WORDS[1]}"
    local script_sub_rel="${word%/*}"
    [[ "$word" != *'/'* ]] && script_sub_rel=
    local script_sub_name="${word##*/}"
    local script_sub_rel_dir="$(__script_name_to_path "${script_sub_rel}")"
    local script_sub_abs_dir="$script_sub_rel_dir"
    local script_dir="${RUN_CLI_DIR}${script_sub_abs_dir}"

    COMPREPLY=($(compgen -W "$(find "$script_dir" -mindepth 1 -maxdepth 1 -type f -name "_ ${script_sub_name}*" -printf "${script_sub_rel:+$script_sub_rel/}%f\n" -o -type d -name "_ ${script_sub_name}*" -printf "${script_sub_rel:+$script_sub_rel/}%f/\n" | sed 's/^_ //g; s/\/_ /\//g; s/.sh$//g'| sort)" -- "$word")) && compopt -o filenames
    [[ $COMPREPLY == */ ]] && compopt -o nospace
    return

  elif [ "${COMP_CWORD}" -gt 1 ]
  then
      # include the actual runnable script
      . "$RUN_CLI_DIR/${SCRIPT_PATH}.sh"

      __complit2
    return
  fi

}

complete -o nosort -F _run_completions run
