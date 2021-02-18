#!/usr/local/bin/bash

function kiq {
  _key=$(sed "s/ /\&\#x20;/g" <<< $@)
  _command=$(yq e ".$_key []" "$HOME/projects/.links.yml")
  echo "$(tput setaf 2)==>$(tput sgr0) $(tput bold)${_command}$(tput sgr0)"
  echo
  eval "$_command"
}
