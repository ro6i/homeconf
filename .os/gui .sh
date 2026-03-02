#!/bin/bash

main() {
  sudo systemctl start gdm.service
  bg
  disown
}
