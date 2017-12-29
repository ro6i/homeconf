#!/bin/bash

set -e

main() {
  local profile_name target_workspace job_number

  profile_name="$1"
  target_workspace="${2:-}"

  nohup firefox -P "$profile_name" &

  job_number="$(echo $!)"

  disown "$job_number"

  sleep 1s
  swaymsg "[con_id=__focused__] move container to workspace number ${target_workspace}, focus"
  sleep 1s
}
