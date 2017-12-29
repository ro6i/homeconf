#!/bin/bash

at . part  :: cmd  list-unmounted-drives


main() {
  udisksctl mount -b "/dev/$part"
}
