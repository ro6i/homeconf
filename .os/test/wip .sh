#!/bin/bash

params() {
at . arg1         list :: here   true false trust tree
at . arg2         list :: from   colors
at . arg3              :: shell  'ls -d */'
at . arg4              :: file
at . arg5              :: cmd    yaml color-objects.yml .$arg2 keys
at . mode      -- mule :: here   state log
at _ optA              :: here   chair stool bench table cabinet door floor tripod
at _ optB              :: here   wide width weight height length depth breadth
at _ optAnd       text
}

mule__log() {
  at _ from  integer
  at _ to    :: here today yesterday
}

mule__state() { return; }

params

main() {
  echo '==>'
  echo "  arg1:    [$arg1]"
  echo "  arg2:    [$arg2]"
  echo "  arg3:    [$arg3]"
  echo "  arg4:    [$arg4]"
  echo "  arg5:    [$arg5]"
  echo "  optA:    [$optA]"
  echo "  optAnd:  [$optAnd]"
  echo "  optB:    [$optB]"
  echo "  mode:    [$mode]"
  echo "    from:  [$from]"
  echo "    to:    [$to]"
}
