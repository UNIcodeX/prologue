import system except getCommand, setCommand, switch, `--`,
  packageName, version, author, description, license, srcDir, binDir, backend,
  skipDirs, skipFiles, skipExt, installDirs, installFiles, installExt, bin, foreignDeps,
  requires, task, packageName
import nimscriptapi, strutils
# Package

version       = "0.3.6"
author        = "flywind"
description   = "Full-Stack Web Framework."
license       = "Apache-2.0"
srcDir        = "src"


# Dependencies
requires "nim >= 1.2.6"
requires "regex >= 0.16.2"
requires "nimcrypto >= 0.5.3"
requires "karax >= 1.1.2"
requires "cookiejar >= 0.2.0"
requires "httpx >= 0.1.0"


# tests
task tests, "Run all tests":
  exec "testament all"

task examples, "Test examples":
  exec "testament r tests/test_examples/examples.nim"

task readme, "Test Readme":
  exec "testament r tests/test_readme/readme.nim"

task docs, "Only for gh-pages, not for users":
  exec "mkdocs build"
  exec "mkdocs gh-deploy"

task apis, "Only for api":
  exec "nim doc --verbosity:0 --warnings:off --project --index:on " &
    "--git.url:https://github.com/planety/prologue " &
    "--git.commit:master " &
    # "--git.devel:master " &
    # "-o:docs/api/theindex.html " &
    "-o:docs/coreapi " &
    "src/prologue.nim"

  exec "nim buildIndex -o:docs/coreapi/theindex.html docs/coreapi"

  exec "nim doc --verbosity:0 --warnings:off --project --index:on " &
    "--git.url:https://github.com/planety/prologue " &
    "--git.commit:master " &
    # "--git.devel:master " &
    # "-o:docs/api/theindex.html " &
    "-o:docs/plugin " &
    "index.nim"

  exec "nim buildIndex -o:docs/plugin/theindex.html docs/plugin"

onExit()