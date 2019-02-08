
list=(
)

for item in ${list[*]}
do
  [ -r "${item}" ] && source "${item}"
done

source "${HOME}/.bashrc"
