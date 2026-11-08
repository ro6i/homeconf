#!/bin/bash


main() {
  nmcli device wifi rescan
  nmcli device wifi list
}
