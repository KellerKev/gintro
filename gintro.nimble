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
  # gobject.nim is NOT patched here — we use the pre-patched repo version instead
  # (see the copy loop below which skips gobject.nim from nim_gi/).
  # The repo's gintro/gobject.nim already has: g_param_spec_pool_free removed,
  # new(x, finalizerfree) → new(x), and the when-not-declared(IOCFlag) guard.

  # cairo.nim: cairoimpl include is needed (provides lineTo, moveTo, save, etc.)
  # On macOS it was disabled due to type duplication, but gen.nim now generates
  # correct set[] types so cairoimpl includes cleanly on both platforms.

  # Fix gst.nim: gen.nim doubles the default value for certain var-typed out
  # parameters, producing malformed code like:
  #   cast[var T](nil) = cast[var T = cast[var T](nil)](nil)
  # Strip the spurious second assignment.
  patchFile(gintroDir / "gst.nim", [
    # gen.nim doubles the default value for certain var-typed out parameters
    ("cast[var gobject.Value](nil) = cast[var gobject.Value = cast[var gobject.Value](nil)](nil)",
     "cast[var gobject.Value](nil)"),
    # parseCapsResult result-overload has orphaned `caps` refs from the var-overload
    ("  result.impl = cast[ptr Caps00](g_boxed_copy(gst_caps_get_type(), result.impl))\n" &
     "  if caps != nil and caps.impl == nil:\n" &
     "    caps.ignoreFinalizer = true\n" &
     "    caps = nil\n" &
     "  if result != nil and result.impl == nil:",
     "  result.impl = cast[ptr Caps00](g_boxed_copy(gst_caps_get_type(), result.impl))\n" &
     "  if result != nil and result.impl == nil:"),
    # acquireBuffer: gen.nim omits 'result =' for the C call (triggered by certain GStreamer typelib versions)
    ("\n  gst_buffer_pool_acquire_buffer(cast[ptr BufferPool00](self.impl)",
     "\n  result = gst_buffer_pool_acquire_buffer(cast[ptr BufferPool00](self.impl)"),
    # parseContext result-overload has orphaned `context` refs from the var-overload
    ("  result.impl = cast[ptr Context00](g_boxed_copy(gst_context_get_type(), result.impl))\n" &
     "  if context != nil and context.impl == nil:\n" &
     "    context.ignoreFinalizer = true\n" &
     "    context = nil\n" &
     "  if result != nil and result.impl == nil:",
     "  result.impl = cast[ptr Context00](g_boxed_copy(gst_context_get_type(), result.impl))\n" &
     "  if result != nil and result.impl == nil:"),
    # parse{Error,Info,Warning}Details result-overloads have orphaned `structure` refs
    ("  result.impl = cast[ptr Structure00](g_boxed_copy(gst_structure_get_type(), result.impl))\n" &
     "  if structure != nil and structure.impl == nil:\n" &
     "    structure.ignoreFinalizer = true\n" &
     "    structure = nil\n" &
     "  if result != nil and result.impl == nil:",
     "  result.impl = cast[ptr Structure00](g_boxed_copy(gst_structure_get_type(), result.impl))\n" &
     "  if result != nil and result.impl == nil:")
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
  # In CI, xvfb-run provides a virtual X display (DISPLAY=:99) before nimble runs.
  # GObject-Introspection loads GTK typelibs which may trigger GDK initialization;
  # the inherited DISPLAY env var satisfies this without needing a real display.
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

  # Install: copy patched generated files back into the package gintro/ directory.
  # Skip gobject.nim — the repo version already has the when-not-declared(IOCFlag)
  # guard applied correctly (patching it from the downloaded oldgtk3 version breaks
  # the surrounding type block context).
  let mods = listFiles(td / wd / "nim_gi")
  for i in mods:
    let j = splitPath(i).tail
    if j == "gobject.nim": continue
    cpFile(i, this / "gintro" / j)

  cd(td)
  rmDir(wd)

before install:
  echo "=== gintro: generating and patching GTK4/GTK3 bindings for Nim 2.x ==="
  prep()
  echo "=== gintro: done ==="
