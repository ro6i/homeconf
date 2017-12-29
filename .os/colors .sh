#!/bin/bash

print_octet() {
  local bg_color fg_color
  printf '  '
  for c in {0..7}
  do
    case "$1" in
      from)
        bg_color=$(( $c + $2 )) ;;
      index)
        case "$2" in
          -) bg_color= ;;
          *) bg_color="$2" ;;
        esac
    esac
    case "$3" in
      from) fg_color=$(( $c + $4 )) ;;
      index) fg_color="$4" ;;
    esac
    if [[ -z "$bg_color" ]]
    then
      printf "$(tput setaf $fg_color )"
    else
      printf "$(tput setab $bg_color)$(tput setaf $fg_color)"
    fi
    printf ' %03d ' $fg_color
    printf "$(tput sgr0)  "
  done
  echo
}

main() {
  echo "$(tput sgr0)"

  print_octet index - from 0
  print_octet index - from 8
  print_octet index - from 16
  print_octet index - from 24
  # echo
  # print_octet index - from 32
  # print_octet index - from 40
  echo
  print_octet from 16 from 24
  print_octet from 16 from 0
  print_octet from 16 from 8
  echo
  print_octet from 24  index  0
  print_octet from 24  index 15
  echo
}
