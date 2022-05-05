
function keyring-unlock() {
  read -rsp "Password: " _pass
  export $(echo -n "$_pass" | gnome-keyring-daemon --replace --unlock)
  unset _pass
}
