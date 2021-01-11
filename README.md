# homeconf

## Apple Script to activate terminal
```
on run
  tell application "System Events"
    set names to name of application processes
    if names contains "Alacritty" then
      set visible of application process "Alacritty" to true
      tell application "Alacritty" to activate
    end if
  end tell
end run
```
