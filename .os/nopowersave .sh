#!/bin/bash

main() {
  echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save_controller
  echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save

  alsactl init
}
