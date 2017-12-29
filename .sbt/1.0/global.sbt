//trapExit := false

import java.time.Instant
import scala.sys.process._

shellPrompt := { state =>
  s"${System.getProperty("user.home")}/.tmux/tools/sbt/prompt-hook".!!
  "\n\033[38;5;31m" + Instant.now.toString + " " + "=" * 50 + s"\n\033[35m${name.value}\033[34m >>\033[0m "
}

scalacOptions in (Compile, console) += "-Xlint:unused"

maxErrors := 2

addCommandAlias("mk", "Test/compile")
