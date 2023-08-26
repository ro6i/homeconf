
_component_delimiter=' '

_nof() {
  echo -e "\001\e[m\002"
}

_setf() {
  echo -e "\001\e[${1}m\002"
}

# _fg_n_base=30
# _fg_s_base=90
# _dark=0
# _red=1
# _green=2
# _yellow=3
# _blue=4
# _magenta=5
# _cyan=6
# _white=7

_fg_nd() { _setf 30 ; }
_fg_nr() { _setf 31 ; }
_fg_ng() { _setf 32 ; }
_fg_ny() { _setf 33 ; }
_fg_nb() { _setf 34 ; }
_fg_nm() { _setf 35 ; }
_fg_nc() { _setf 36 ; }
_fg_nw() { _setf 37 ; }

_fg_sd() { _setf 90 ; }
_fg_sr() { _setf 91 ; }
_fg_sg() { _setf 92 ; }
_fg_sy() { _setf 93 ; }
_fg_sb() { _setf 94 ; }
_fg_sm() { _setf 95 ; }
_fg_sc() { _setf 96 ; }
_fg_sw() { _setf 97 ; }

_bg_nb() { _setf 40 ; }
_bg_nw() { _setf 47 ; }

_bg_sb() { _setf 100 ; }
_bg_sw() { _setf 107 ; }

_component() {
  if [[ -z "$2" ]];
  then
    echo ''
  else
    [[ -z "$1" ]] && _delimiter= || _delimiter="$_component_delimiter"
    echo " $(_fg_sw)$1$(_fg_sd)${_delimiter}$2$(_nof)"
  fi
}

_parse_git_status() {
  local _status=$(git status --short 2> /dev/null | head)
  if [[ ! -z "$_status" ]]
  then
    local _traits=()
    if [[ ! -z "$(git diff --exit-code)" ]]; then _traits+=" $(_fg_nr)unstaged"; fi
    if [[ ! -z "$(git ls-files --other --exclude-standard --directory --no-empty-directory)" ]]; then _traits+=" $(_fg_sr)untracked"; fi
    if [[ ! -z "$(git diff --cached --exit-code)" ]]; then _traits+=" $(_fg_ng)staged"; fi
    _status="${_traits[@]}"
    _status="${_status:1}"
    _status="$(_fg_sw)($_status$(_fg_sw))"
  fi
  echo "$_status"
}

_prompt_conf_value() {
  _name="PROMPT_CONF_${1^^}"
  echo "${!_name}"
}

_prompt_component_git() {
  local status_color=37
  local branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' -e 's/^[ ]*//' -e 's/[ ]*$//')"
  if [[ $branch == "" ]]
  then
    echo ""
  else
    local status="$(_parse_git_status)"
    status_color=$([[ $status == "" ]] && echo 37 || echo 33)
    echo -e "$(_component ' git' "$(_setf ${status_color})${branch}${status}$(_nof)")"
  fi
}

_prompt_path() {
  local d="$(dirs)"
  local sep="$(_fg_sd)\/$(_fg_sw)"
  local dn="$(dirname "$d")"
  local pdir="$(_fg_nw)${dn:0:1}$(_fg_sw)$(echo "${dn:1}" | sed "s/\//$sep/g")"
  if [[ "$d" == '~' || "$d" == '/' ]];
  then
    echo -e "$(_fg_nw)$d$(_nof)"
  else
    local decorated_base_name="$(_fg_nw)$(basename "$d")"
    if [[ -f './.alias' ]]
    then
      decorated_base_name="$(_fg_ny)\$$(_fg_sy)$(cat '.alias')"
    fi
    echo -e "$pdir$(_fg_sd)/$decorated_base_name$(_nof)"
  fi
}

PROMPT_TIME_FORMAT='%m-%d %H:%M'

_prompt_time() {
  is_on="$(_prompt_conf_value time)"
  if [[ "$is_on" == 'off' ]]
  then
    return
  fi
  echo -e " $(_fg_sd)$(date +"${PROMPT_TIME_FORMAT}")$(_nof)"
  #echo -e " $(_setf '90')$(date +'%m-%d') $(_setf '97')$(date +'%H:%M')$(_nof)"
}

_prompt_jobs() {
  local j="$(($(jobs -p | wc -l)))"
  if [[ $j > 0 ]]
  then
    echo -e "$(_component ' jobs' "$(_fg_sr)$j")"
  fi
}

_prompt_hb() {
  local _time=" $(date +"${PROMPT_TIME_FORMAT}")"
  local _session_width=$(tput cols)
  local _width=$(( 80 < $_session_width ? 80 : $_session_width ))
  local _length=$(( $_width - ${#_time} ))
  echo "$(_fg_sd)$(printf "%${_length}s" | tr ' ' '-')$(_prompt_time)$(_nof)"
}

_prompt_component_env() {
  local prefixed=0
  env | grep 'PROMPT_CONF_ENV_' | sed 's/=.*//' | sed 's/^PROMPT_CONF_ENV_//' | sort | while read -r envVarId
    do
      [[ $prefixed == 0 ]] && printf '\n'
      if [[ "$(_prompt_conf_value ENV_$envVarId)" == 'on' ]]
      then
        prefixed=$((prefixed + 1))
        local value="${!envVarId}"
        [[ "$value" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]] && value="${value:0:8}..${value: -2}"
        printf "$(_component '' "$(_fg_nd)[$(_fg_sw)$envVarId $(_setf $((91 + $prefixed)))$(_bg_nb)${value}$(_nof)$(_fg_nd)]$(_nof)")"
      fi
    done
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
  on)
    _name="PROMPT_CONF_${2^^}"
    _val="${!_name}"
    export $_name='on'
    ;;
  off)
    _name="PROMPT_CONF_${2^^}"
    _val="${!_name}"
    unset $_name
    ;;
  *)
    ;;
  esac
}
