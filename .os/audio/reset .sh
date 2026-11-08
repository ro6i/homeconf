#!/bin/bash


main() {
  rm -r ~/.local/state/wireplumber/*
  systemctl --user restart pipewire pipewire-pulse wireplumber
}
