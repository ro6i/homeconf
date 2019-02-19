maxErrors := 2
//trapExit := false

shellPrompt := { state =>
  s"\n\033[93m${name.value} \033[92m${Project.extract(state).currentProject.id}\033[35m >>\033[0m "
}
