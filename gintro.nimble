# Package

version       = "1.0.0"
author        = "kevin"
description   = "High level GObject-Introspection based GTK4/GTK3 bindings (revived, Nim 2.x compatible)"
license       = "MIT"
skipDirs      = @["examples", "tests"]

# Dependencies

requires "nim >= 2.0.0"

when defined(nimdistros):
  import distros
  if detectOs(Ubuntu) or detectOs(Debian):
    foreignDep "libgtk-4-dev"
    foreignDep "libgirepository1.0-dev"
  elif detectOs(Fedora):
    foreignDep "gtk4-devel"
    foreignDep "gobject-introspection-devel"

import os, strutils

proc patchFile(path: string; replacements: openArray[(string, string)]) =
  if not fileExists(path): return
  var content = readFile(path)
  for (old, new) in replacements:
    content = content.replace(old, new)
  writeFile(path, content)

proc patchGeneratedBindings(gintroDir: string) =
  # gtk4.nim: default flags value is already correct ({}) now that the size pragma
  # is removed from set aliases — no patch needed here.

  # Fix gobject.nim: g_param_spec_pool_free does not exist in GObject API;
  # remove the call and leave self.impl = nil intact.
  patchFile(gintroDir / "gobject.nim", [
    ("g_param_spec_pool_free(self.impl)", "discard # g_param_spec_pool_free unavailable"),
    ("new(x, finalizerfree)", "new(x)")
  ])

  # Fix cairo.nim: comment out cairoimpl include to avoid duplicate types
  patchFile(gintroDir / "cairo.nim", [
    ("include cairoimpl", "# include cairoimpl  # disabled: types already defined in generated cairo.nim")
  ])

  # Fix glib.nim: relax early forward-decl return types (ptr glib.List not yet defined).
  # The generated proc spans two lines so we match only up to the pragma brace.
  patchFile(gintroDir / "glib.nim", [
    ("): ptr glib.List {.",
     "): pointer {."),
    ("proc g_markup_parse_context_get_element_stack(self: ptr MarkupParseContext00): ptr glib.SList",
     "proc g_markup_parse_context_get_element_stack(self: ptr MarkupParseContext00): pointer"),
    # Comment out duplicate allocator procs (node/slist variants clash with the list version)
    ("proc popAllocator*() {.\n    importc: \"g_node_pop_allocator\", libprag.}",
     "# proc popAllocator (g_node_pop_allocator) removed: duplicate"),
    ("proc popAllocator*() {.\n    importc: \"g_slist_pop_allocator\", libprag.}",
     "# proc popAllocator (g_slist_pop_allocator) removed: duplicate"),
    ("proc pushAllocator*(allocator: Allocator) =\n  g_node_push_allocator(cast[ptr Allocator00](allocator.impl))",
     "# proc pushAllocator (g_node) removed: duplicate"),
    ("proc pushAllocator*(allocator: Allocator) =\n  g_slist_push_allocator(cast[ptr Allocator00](allocator.impl))",
     "# proc pushAllocator (g_slist) removed: duplicate")
  ])

proc prep =
  let this = thisDir()
  let td = getTempDir()
  cd(td)
  let wd = "gintro_build"
  if dirExists(wd):
    rmDir(wd)
  mkDir(wd)
  cd(wd)

  cpFile(this / "tests" / "gen.nim", td / wd / "gen.nim")
  cpFile(this / "tests" / "combinatorics.nim", td / wd / "combinatorics.nim")
  cpFile(this / "tests" / "maxby.nim", td / wd / "maxby.nim")

  cd(td)
  cd(wd)

  try:
    exec("wget https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/gobject.nim -O gobject.nim")
    exec("wget https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/glib.nim -O glib.nim")
    exec("wget https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/gir.nim -O gir.nim")
  except:
    try:
      exec("curl -fsSLo gobject.nim https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/gobject.nim")
      exec("curl -fsSLo glib.nim https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/glib.nim")
      exec("curl -fsSLo gir.nim https://raw.githubusercontent.com/StefanSalewski/oldgtk3/master/oldgtk3/gir.nim")
    except:
      echo "ERROR: Could not download bootstrap files (gobject.nim, glib.nim, gir.nim)."
      echo "Ensure wget or curl is available, then retry."
      quit(1)

  exec("nim c gen.nim")
  mkDir("nim_gi")
  exec(td / wd / "gen")   # generate GTK3 bindings
  exec(td / wd / "gen 1") # generate GTK4 + libsoup3 bindings

  # Copy helper modules (not generated, sourced from repo)
  cpFile(this / "gintro" / "gimplglib.nim", td / wd / "nim_gi" / "gimplglib.nim")
  cpFile(this / "gintro" / "gimplgobj.nim", td / wd / "nim_gi" / "gimplgobj.nim")
  cpFile(this / "gintro" / "gimplgtk.nim",  td / wd / "nim_gi" / "gimplgtk.nim")
  cpFile(this / "gintro" / "gimplgtk4.nim", td / wd / "nim_gi" / "gimplgtk4.nim")
  if fileExists(this / "gintro" / "gimplgst.nim"):
    cpFile(this / "gintro" / "gimplgst.nim", td / wd / "nim_gi" / "gimplgst.nim")

  # Apply Nim 2.x compatibility patches to generated files
  patchGeneratedBindings(td / wd / "nim_gi")

  # Install: copy patched generated files back into the package gintro/ directory
  let mods = listFiles(td / wd / "nim_gi")
  for i in mods:
    let j = splitPath(i).tail
    cpFile(i, this / "gintro" / j)

  cd(td)
  rmDir(wd)

before install:
  echo "=== gintro: generating and patching GTK4/GTK3 bindings for Nim 2.x ==="
  prep()
  echo "=== gintro: done ==="
