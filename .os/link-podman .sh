#!/bin/bash

main() {
  sudo ln -sf /run/user/$EUID/podman/podman.sock /var/run/docker.sock
}
