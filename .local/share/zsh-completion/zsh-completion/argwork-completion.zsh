#!/bin/zsh

__argwork_one() {
  local index var="$2"

  case "$1" in
    .) index="$__argwork_counter" ;;
    *) index="$1" ;;
  esac

  if [[ "$index" != '_' && "$var" != '_' ]]
  then
    eval "$var='${words[$(($index + 2))]}'"
  fi

  case "$index" in
    _)
      if [[ ! -v __argwork_optional_arg_vars["$var"] ]]
      then
        __argwork_optional_param_count+=1
        __argwork_optional_arg_vars["$var"]="$var"
      fi
      index="$var"
      ;;
    *)
      if (($__argwork_positional_param_count < $index))
      then
        __argwork_positional_param_count="$index"
      fi
      __argwork_positional_arg_vars[$index]="$var"
      ;;
  esac

  shift 2

  local subcommand
  if [[ "$1" == '--' ]]
  then
    shift
    subcommand="$1"
  fi

  for param in "$@"
  do
    if [[ "$param" == '::' ]]
    then
      shift
      break
    else
      shift
    fi
  done

  if (( $# == 0 ))
  then
    return
  fi

  local spec="$1";
  shift
  case "$spec" in
    from)
      __argwork_line_types["$index"]='from'
      __argwork_line_values["$index"]="$1"
      ;;
    here)
      __argwork_line_types["$index"]='here'
      # local arg_list=(${@:1})
      # __argwork_line_values["$index"]=$(IFS=, ; echo "${arg_list[*]}")
      __argwork_line_values["$index"]='here'
      shift
      local n=$#
      for i in $(seq 1 $n)
      do
        eval "__argwork_line_value__${index}__${i}='${(P)i}'"
      done
      eval "__argwork_line_value__${index}_len=$n"
      ;;
    shell)
      __argwork_line_types["$index"]='shell'
      __argwork_line_values["$index"]="$1"
      ;;
    cmd)
      __argwork_line_types["$index"]='cmd'
      __argwork_line_values["$index"]="$1"
      shift
      local n=$#
      for i in $(seq 1 $n)
      do
        eval "__argwork_line_value__${index}__${i}='${(P)i}'"
      done
      eval "__argwork_line_value__${index}_len=$n"
      ;;
    dir)
      __argwork_line_types["$index"]='dir'
      __argwork_line_values["$index"]='[/path/to/directory]'
      ;;
    file)
      __argwork_line_types["$index"]='file'
      __argwork_line_values["$index"]='[/path/to/file]'
      ;;
    *)
      ;;
  esac

  if [[ -n "$subcommand" && -n "${(P)var}" ]]
  then
    local function_name="${subcommand}__${(P)var}"
    if typeset -f "$function_name" > /dev/null 2>&1
    then
      "$function_name"
    fi
  fi
}

__argwork_one_help() {
  local index var="$2"

  case "$1" in
    .) index="$__argwork_counter" ;;
    *) index="$1" ;;
  esac

  if [[ "$index" != '_' && "$var" != '_' ]]
  then
    eval "$var='${words[$(($index + 1))]}'"
  fi

  case "$index" in
    _)
      __argwork_help_spec+=" ($var)"
      ;;
    *)
      __argwork_help_spec+=" [$index:$var]"
      ;;
  esac

  shift 2

  local subcommand
  if [[ "$1" == '--' ]]
  then
    shift
    subcommand="$1"
    for param in "$@"
    do
      if [[ "$param" == '::' ]]
      then
        shift
        break
      else
        shift
      fi
    done

    local spec="$1";
    shift
    case "$spec" in
      here)
        if [[ ! -z "$subcommand" ]]
        then
          __argwork_help_spec+='{'
          for switch in "$@"
          do
            if typeset -f "${subcommand}__${switch}" > /dev/null 2>&1
            then
              __argwork_help_spec+=" $switch:"
              eval "${subcommand}__${switch}"
            fi
          done
          __argwork_help_spec+=' }'
        fi
        ;;
      *)
        ;;
    esac
  fi
}

__argwork_complete() {
  # Optionals may look like --param value, i.e. 3 components
  if [[ $CURRENT -gt $(($__argwork_positional_param_count + $__argwork_optional_param_count * 3 + 1 + 1)) ]]
  then
    return
  fi

  local sector=POSITIONAL
  if [[ $CURRENT -gt $(( $__argwork_positional_param_count + 1 + 1 )) ]]
  then
    sector=OPTIONAL
  fi

  local key
  local key_shift=0
  case "$sector" in
    POSITIONAL)
      key="$(($CURRENT - 1 - 1))"
      ;;
    OPTIONAL)
      if [[ "${words[$(($CURRENT - 1))][1,2]}" == '--' ]]
      then
        key="${words[$(($CURRENT - 1))][3,-1]}"
        key_shift=0
        if [[ -z "$key" || -z "__argwork_optional_arg_vars["$key"]" ]]
        then
          return
        fi
      else
        compadd -P '--' -a __argwork_optional_arg_vars
        return
      fi
      ;;
  esac

  local word_index=$(($CURRENT + $key_shift))

  local prefix=()
  local word="${words[$word_index]}"
  local comp_word="${word}"
  if [[ "$word" == *,* ]]
  then
    comp_word="${word##*,}"
    prefix=( -P "${word%,*}," )
  fi

  case "${__argwork_line_types["$key"]}" in
    from)
      if [[ -f "${ARGWORK_CLI_DIR}/.opts/${__argwork_line_values["$key"]}" ]]
      then
        local opts_list=( "${(f)$(cat "${ARGWORK_CLI_DIR}/.opts/${__argwork_line_values["$key"]}")}" )
        compadd ${prefix[*]} -a opts_list
      fi
      ;;

    here)
      local opts_var="__argwork_line_value__$key"
      local opts_len="__argwork_line_value__${key}_len"
      local n="${(P)opts_len}"
      local opts_list=()
      local param_var_name
      for i in $(seq 1 $n)
      do
        param_var_name="${opts_var}__${i}"
        opts_list[$i]="${(P)param_var_name}"
      done
      compadd ${prefix[*]} -a opts_list
      ;;

    shell)
      local shell_code="${__argwork_line_values["$key"]}"
      local opts_list=( "${(f)$(eval "$shell_code")}" )
      compadd ${prefix[*]} -a opts_list
      ;;

    cmd)
      local command_name="${__argwork_line_values["$key"]}"
      local command_path
      if [[ -x "$ARGWORK_CLI_DIR/.bin/$command_name" ]]
      then
        command_path="$ARGWORK_CLI_DIR/.bin/$command_name"
      else
        command_path="$command_name"
      fi
      local command_line="'$command_path'"
      local command_args_var="__argwork_line_value__$key"
      local command_args_var_len="__argwork_line_value__${key}_len"
      local n="${(P)command_args_var_len}"
      local param_var_name
      for i in $(seq 1 $n)
      do
        param_var_name="${command_args_var}__${i}"
        command_line+=" '${(P)param_var_name}'"
      done
      local opts_list=( "${(f)$(eval $command_line)}" )
      compadd ${prefix[*]} -a opts_list
      ;;

    dir)
      _directories
      ;;

    file)
      _files
      ;;

    _)
      compadd '_'
      ;;

    *)
      ;;
  esac
}

__argwork_complete_inspect() {
  declare -A arg_map
  local sector=POSITIONAL
  local option_name=

  for index in $(seq 3 "$((${#words} - 1))")
  do
    local word="${words[$index]}"

    if [[ "${word[1,2]}" == '--' ]]
    then
      sector=OPTIONAL
      if [[ ! -z "$option_name" ]]
      then
        return
      fi
      option_name="${word[3,-1]}"
    else
      case $sector in
        OPTIONAL)
          if [[ -z "$option_name" ]]
          then
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
          arg_map["$(( $index - 2 ))"]="$word"
          ;;
      esac
    fi
  done

  for key in $(seq 1 $__argwork_positional_param_count)
  do
    local field="${key}:${__argwork_positional_arg_vars[$key]}"
    __argwork_inspect_spec+="$(printf "\n  %s%*s = %s" "$field" "$((19 - ${#key} - ${#__argwork_positional_arg_vars["$key"]}))" '' "${arg_map["$key"]}")"
  done
  for option_name in "${(@vo)__argwork_optional_arg_vars}"
  do
    __argwork_inspect_spec+="$(printf "\n  %s%*s = %s" "_:$option_name" "$((18 - ${#option_name}))" '' "${arg_map["$option_name"]}")"
  done
}

_argwork_completion() {
  declare -A __argwork_line_types
  declare -A __argwork_line_values
  declare -a __argwork_positional_arg_vars
  declare -A __argwork_optional_arg_vars

  declare -i __argwork_counter=0
  declare -i __argwork_positional_param_count=0
  declare -i __argwork_optional_param_count=0

  local argwork_script_path="${words[2]}"
  local argwork_abs_script_path="$ARGWORK_CLI_DIR/${argwork_script_path} .sh"

  if [ "$CURRENT" -gt 2 ] && [ ! -f "$argwork_abs_script_path" ]
  then
    compadd '' ''
    return
  fi

  local argwork_global_env_path="$ARGWORK_CLI_DIR/.env.sh"
  [[ -f "$argwork_global_env_path" ]] && . "$argwork_global_env_path"


  if [[ "${words[$CURRENT]}" == '?' ]]
  then
    __argwork_completion_mode=HELP
    __argwork_help_spec='usage: '
    # Include the actual runnable script
    . "$argwork_abs_script_path"

    compadd -x "$__argwork_help_spec"

  elif [[ "${words[$CURRENT]}" == '#' ]]
  then
    __argwork_completion_mode=INSPECT
    __argwork_inspect_spec='inspect: '
    # Include the actual runnable script
    . "$argwork_abs_script_path"

    __argwork_complete_inspect

    compadd -x "$__argwork_inspect_spec"

  elif [ "$CURRENT" -eq 2 ]
  then
    # The first section is completed with script names located at the ARGWORK_CLI_DIR
    local IFS=$'\n'
    local word="${words[2]}"
    local script_sub_rel="${word%/*}"
    [[ "$word" != *'/'* ]] && script_sub_rel=
    local script_sub_name="${word##*/}"
    local script_sub_abs_dir="$script_sub_rel"
    local script_dir="$ARGWORK_CLI_DIR/$script_sub_abs_dir"

    local opts_list=($(find "$script_dir" -mindepth 1 -maxdepth 1 -not -name '.*' -type f -name "${script_sub_name}* .sh" -printf "${script_sub_rel:+$script_sub_rel/}%f\n" -o -not -name '.*' -type d -name "${script_sub_name}*" -printf "${script_sub_rel:+$script_sub_rel/}%f/\n" | sed 's/ .sh$//g'| sort | grep "^$word"))
    local slash='/'

    if [[ -n ${(M)opts_list:#*$slash} ]]
    then
      compadd -S '' -a opts_list
    else
      compadd -a opts_list
    fi

  elif [ "$CURRENT" -gt 2 ]
  then
    __argwork_completion_mode=COMPLETE
    # Source the target argwork
    . "$argwork_abs_script_path"
    # eval "$(sed '/^main() {/Q')" "$argwork_abs_script_path"

    __argwork_complete
  fi
}

at() {
  __argwork_counter+=1
  case "$__argwork_completion_mode" in
    HELP)     __argwork_one_help "$@" ;;
    INSPECT)  __argwork_one "$@" ;;
    COMPLETE) __argwork_one "$@" ;;
  esac
}
