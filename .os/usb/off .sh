#!/bin/bash

at . part  :: cmd  list-mounted-drives


main() {
  local device="$(lsblk -pJ | jq -r ".blockdevices.[] | select(.name | test(\"/dev/sd\")) | select(.children.[0].name == \"/dev/$part\") | .name")"
  if [[ -z "$device" ]]
  then
    >&2 echo "no device found for drive $part"
    return 1
  fi

  udisksctl unmount -b "/dev/$part"
  udisksctl power-off -b "$device"
}
