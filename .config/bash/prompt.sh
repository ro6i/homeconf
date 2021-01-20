
_component_delimiter=' '

_nof() {
  echo -e "\001\e[m\002"
}

_setf() {
  echo -e "\001\e[${1}m\002"
}

_component() {
  if [[ -z "$2" ]];
  then
    echo ''
  else
    echo " $(_setf '100;97')$1${_component_delimiter}$2$(_nof)"
  fi
}

_parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//'
}

_parse_git_status() {
  git status --short 2> /dev/null | head
}

_prompt_conf_value() {
  _name="PROMPT_CONF_${1^^}"
  echo "${!_name}"
}

_prompt_component_git() {
  local status_color=37
  local branch="$(_parse_git_branch)"
  if [[ $branch == "" ]]
  then
    echo ""
  else
    local status="$(_parse_git_status)"
    if [[ $status == "" ]]
    then
      status_color=37
    else
      status_color=33
    fi
    echo -e "$(_component 'git' "$(_setf ${status_color})${branch}")"
  fi
}

_prompt_component_k8s() {
  if [[ $(_prompt_conf_value k8s) != 'on' ]]
  then
    return
  fi
  context=$(kubectl config current-context)
  namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
  echo -e "$(_component 'k8s' "$(_setf 32)${namespace}$(_setf 97)@...$(_setf 37)${context##*_}")"
}

_prompt_path() {
  local d="$(dirs)"
  local sep="$(_setf '90')\/$(_setf '97')"
  local dn="$(dirname "$d")"
  local pdir="$(_setf 37)${dn:0:1}$(_setf '97')$(echo "${dn:1}" | sed "s/\//$sep/g")"
  if [[ "$d" == '~' || "$d" == '/' ]];
  then
    echo -e "$(_setf '100;37')$d$(_nof)"
  else
    echo -e "$pdir$(_setf 90)/$(_setf 37)$(basename "$d")$(_nof)"
  fi
}

_prompt_time() {
  if [[ $(_prompt_conf_value time) != 'on' ]]
  then
    return
  fi
  echo -e " $(_setf '90')$(date +'%m-%d %H:%M')$(_nof)"
  #echo -e " $(_setf '90')$(date +'%m-%d') $(_setf '97')$(date +'%H:%M')$(_nof)"
}

_prompt_jobs() {
  local j="$(($(jobs -p | wc -l)))"
  if [[ $j > 0 ]]
  then
    echo -e "$(_component 'jobs' "$(_setf 91)$j")"
  fi
}

# prompt configuration cli
prompt() {
  case "$1" in
  toggle)
    _name="PROMPT_CONF_${2^^}"
    _val="${!_name}"
    if [[ "$_val" != 'on' ]]
    then
      export $_name='on'
    else
      unset $_name
    fi
    ;;
  *)
    ;;
  esac
}
