#!/bin/bash

main() {
  # link rancher-desktop
  sudo ln -s ~/.rd/docker.sock /var/run/docker.sock
}
