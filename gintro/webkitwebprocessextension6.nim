# dependencies:
# GModule-2.0
# HarfBuzz-0.0
# JavaScriptCore-6.0
# GObject-2.0
# Gdk-4.0
# Gsk-4.0
# freetype2-2.0
# Soup-3.0
# GLib-2.0
# cairo-1.0
# Gtk-4.0
# Gio-2.0
# Pango-1.0
# Graphene-1.0
# PangoCairo-1.0
# GdkPixbuf-2.0
# immediate dependencies:
# Soup-3.0
# JavaScriptCore-6.0
# Gtk-4.0
# libraries:
# libwebkitgtk-6.0.so.4,libjavascriptcoregtk-6.0.so.1
{.warning[UnusedImport]: off.}
import gmodule, harfbuzz, javascriptcore6, gobject, gdk4, gsk, freetype2, soup3, glib, cairo, gtk4, gio, pango, graphene, pangocairo, gdkpixbuf
const Lib = "libwebkitgtk-6.0.so.4"
{.pragma: libprag, cdecl, dynlib: Lib.}

proc finalizeGObject*[T](o: ref T) =
  if not o.ignoreFinalizer:
    gobject.g_object_remove_toggle_ref(o.impl, gobject.toggleNotify, addr(o[]))

type
  ConsoleMessage00* {.pure.} = object
  ConsoleMessage* = ref object
    impl*: ptr ConsoleMessage00
    ignoreFinalizer*: bool

proc webkit_console_message_get_type*(): GType {.importc, libprag.}

proc gBoxedFreeWebKitConsoleMessage*(self: ConsoleMessage) =
  if not self.ignoreFinalizer:
    boxedFree(webkit_console_message_get_type(), cast[ptr ConsoleMessage00](self.impl))

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(ConsoleMessage()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    if not self.ignoreFinalizer and self.impl != nil:
      boxedFree(webkit_console_message_get_type(), cast[ptr ConsoleMessage00](self.impl))
      self.impl = nil

proc newWithFinalizer*(x: var ConsoleMessage) =
  when defined(gcDestructors):
    new(x)
  else:
    new(x, gBoxedFreeWebKitConsoleMessage)

proc webkit_console_message_free(self: ptr ConsoleMessage00) {.
    importc, libprag.}

proc free*(self: ConsoleMessage) =
  webkit_console_message_free(cast[ptr ConsoleMessage00](self.impl))

proc finalizerfree*(self: ConsoleMessage) =
  if not self.ignoreFinalizer:
    webkit_console_message_free(cast[ptr ConsoleMessage00](self.impl))

proc webkit_console_message_copy(self: ptr ConsoleMessage00): ptr ConsoleMessage00 {.
    importc, libprag.}

proc copy*(self: ConsoleMessage): ConsoleMessage =
  fnew(result, gBoxedFreeWebKitConsoleMessage)
  result.impl = webkit_console_message_copy(cast[ptr ConsoleMessage00](self.impl))

proc webkit_console_message_get_line(self: ptr ConsoleMessage00): uint32 {.
    importc, libprag.}

proc getLine*(self: ConsoleMessage): int =
  int(webkit_console_message_get_line(cast[ptr ConsoleMessage00](self.impl)))

proc line*(self: ConsoleMessage): int =
  int(webkit_console_message_get_line(cast[ptr ConsoleMessage00](self.impl)))

proc webkit_console_message_get_source_id(self: ptr ConsoleMessage00): cstring {.
    importc, libprag.}

proc getSourceId*(self: ConsoleMessage): string =
  result = $webkit_console_message_get_source_id(cast[ptr ConsoleMessage00](self.impl))

proc sourceId*(self: ConsoleMessage): string =
  result = $webkit_console_message_get_source_id(cast[ptr ConsoleMessage00](self.impl))

proc webkit_console_message_get_text(self: ptr ConsoleMessage00): cstring {.
    importc, libprag.}

proc getText*(self: ConsoleMessage): string =
  result = $webkit_console_message_get_text(cast[ptr ConsoleMessage00](self.impl))

proc text*(self: ConsoleMessage): string =
  result = $webkit_console_message_get_text(cast[ptr ConsoleMessage00](self.impl))

type
  ConsoleMessageLevel* {.size: sizeof(cint), pure.} = enum
    info = 0
    log = 1
    warning = 2
    error = 3
    debug = 4

proc webkit_console_message_get_level(self: ptr ConsoleMessage00): ConsoleMessageLevel {.
    importc, libprag.}

proc getLevel*(self: ConsoleMessage): ConsoleMessageLevel =
  webkit_console_message_get_level(cast[ptr ConsoleMessage00](self.impl))

proc level*(self: ConsoleMessage): ConsoleMessageLevel =
  webkit_console_message_get_level(cast[ptr ConsoleMessage00](self.impl))

type
  ConsoleMessageSource* {.size: sizeof(cint), pure.} = enum
    javascript = 0
    network = 1
    consoleApi = 2
    security = 3
    other = 4

proc webkit_console_message_get_source(self: ptr ConsoleMessage00): ConsoleMessageSource {.
    importc, libprag.}

proc getSource*(self: ConsoleMessage): ConsoleMessageSource =
  webkit_console_message_get_source(cast[ptr ConsoleMessage00](self.impl))

proc source*(self: ConsoleMessage): ConsoleMessageSource =
  webkit_console_message_get_source(cast[ptr ConsoleMessage00](self.impl))

type
  ContextMenu* = ref object of gobject.Object
  ContextMenu00* = object of gobject.Object00

proc webkit_context_menu_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(ContextMenu()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  ContextMenuAction* {.size: sizeof(cint), pure.} = enum
    noAction = 0
    openLink = 1
    openLinkInNewWindow = 2
    downloadLinkToDisk = 3
    copyLinkToClipboard = 4
    openImageInNewWindow = 5
    downloadImageToDisk = 6
    copyImageToClipboard = 7
    copyImageUrlToClipboard = 8
    openFrameInNewWindow = 9
    goBack = 10
    goForward = 11
    stop = 12
    reload = 13
    copy = 14
    cut = 15
    paste = 16
    delete = 17
    selectAll = 18
    inputMethods = 19
    unicode = 20
    spellingGuess = 21
    noGuessesFound = 22
    ignoreSpelling = 23
    learnSpelling = 24
    ignoreGrammar = 25
    fontMenu = 26
    bold = 27
    italic = 28
    underline = 29
    outline = 30
    inspectElement = 31
    openVideoInNewWindow = 32
    openAudioInNewWindow = 33
    copyVideoLinkToClipboard = 34
    copyAudioLinkToClipboard = 35
    toggleMediaControls = 36
    toggleMediaLoop = 37
    enterVideoFullscreen = 38
    mediaPlay = 39
    mediaPause = 40
    mediaMute = 41
    downloadVideoToDisk = 42
    downloadAudioToDisk = 43
    insertEmoji = 44
    pasteAsPlainText = 45
    custom = 10000

type
  ContextMenuItem* = ref object of gobject.InitiallyUnowned
  ContextMenuItem00* = object of gobject.InitiallyUnowned00

proc webkit_context_menu_item_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(ContextMenuItem()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  Frame* = ref object of gobject.Object
  Frame00* = object of gobject.Object00

proc webkit_frame_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(Frame()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc webkit_frame_get_id(self: ptr Frame00): uint64 {.
    importc, libprag.}

proc getId*(self: Frame): uint64 =
  webkit_frame_get_id(cast[ptr Frame00](self.impl))

proc id*(self: Frame): uint64 =
  webkit_frame_get_id(cast[ptr Frame00](self.impl))

proc webkit_frame_get_js_context(self: ptr Frame00): ptr javascriptcore6.Context00 {.
    importc, libprag.}

proc getJsContext*(self: Frame): javascriptcore6.Context =
  let gobj = webkit_frame_get_js_context(cast[ptr Frame00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, javascriptcore6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc jsContext*(self: Frame): javascriptcore6.Context =
  let gobj = webkit_frame_get_js_context(cast[ptr Frame00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, javascriptcore6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_frame_get_uri(self: ptr Frame00): cstring {.
    importc, libprag.}

proc getUri*(self: Frame): string =
  result = $webkit_frame_get_uri(cast[ptr Frame00](self.impl))

proc uri*(self: Frame): string =
  result = $webkit_frame_get_uri(cast[ptr Frame00](self.impl))

proc webkit_frame_is_main_frame(self: ptr Frame00): gboolean {.
    importc, libprag.}

proc isMainFrame*(self: Frame): bool =
  toBool(webkit_frame_is_main_frame(cast[ptr Frame00](self.impl)))

type
  WebHitTestResult* = ref object of gobject.Object
  WebHitTestResult00* = object of gobject.Object00

proc webkit_web_hit_test_result_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(WebHitTestResult()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc webkit_web_hit_test_result_context_is_editable(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsEditable*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_editable(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_context_is_image(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsImage*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_image(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_context_is_link(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsLink*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_link(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_context_is_media(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsMedia*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_media(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_context_is_scrollbar(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsScrollbar*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_scrollbar(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_context_is_selection(self: ptr WebHitTestResult00): gboolean {.
    importc, libprag.}

proc contextIsSelection*(self: WebHitTestResult): bool =
  toBool(webkit_web_hit_test_result_context_is_selection(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_get_context(self: ptr WebHitTestResult00): uint32 {.
    importc, libprag.}

proc getContext*(self: WebHitTestResult): int =
  int(webkit_web_hit_test_result_get_context(cast[ptr WebHitTestResult00](self.impl)))

proc context*(self: WebHitTestResult): int =
  int(webkit_web_hit_test_result_get_context(cast[ptr WebHitTestResult00](self.impl)))

proc webkit_web_hit_test_result_get_image_uri(self: ptr WebHitTestResult00): cstring {.
    importc, libprag.}

proc getImageUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_image_uri(cast[ptr WebHitTestResult00](self.impl))

proc imageUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_image_uri(cast[ptr WebHitTestResult00](self.impl))

proc webkit_web_hit_test_result_get_link_label(self: ptr WebHitTestResult00): cstring {.
    importc, libprag.}

proc getLinkLabel*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_label(cast[ptr WebHitTestResult00](self.impl))

proc linkLabel*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_label(cast[ptr WebHitTestResult00](self.impl))

proc webkit_web_hit_test_result_get_link_title(self: ptr WebHitTestResult00): cstring {.
    importc, libprag.}

proc getLinkTitle*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_title(cast[ptr WebHitTestResult00](self.impl))

proc linkTitle*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_title(cast[ptr WebHitTestResult00](self.impl))

proc webkit_web_hit_test_result_get_link_uri(self: ptr WebHitTestResult00): cstring {.
    importc, libprag.}

proc getLinkUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_uri(cast[ptr WebHitTestResult00](self.impl))

proc linkUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_link_uri(cast[ptr WebHitTestResult00](self.impl))

proc webkit_web_hit_test_result_get_media_uri(self: ptr WebHitTestResult00): cstring {.
    importc, libprag.}

proc getMediaUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_media_uri(cast[ptr WebHitTestResult00](self.impl))

proc mediaUri*(self: WebHitTestResult): string =
  result = $webkit_web_hit_test_result_get_media_uri(cast[ptr WebHitTestResult00](self.impl))

type
  URIRequest* = ref object of gobject.Object
  URIRequest00* = object of gobject.Object00

proc webkit_uri_request_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(URIRequest()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  URIResponse* = ref object of gobject.Object
  URIResponse00* = object of gobject.Object00

proc webkit_uri_response_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(URIResponse()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  UserMessage* = ref object of gobject.InitiallyUnowned
  UserMessage00* = object of gobject.InitiallyUnowned00

proc webkit_user_message_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(UserMessage()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  WebPage* = ref object of gobject.Object
  WebPage00* = object of gobject.Object00

proc webkit_web_page_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(WebPage()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc scConsoleMessageSent*(self: WebPage;  p: proc (self: ptr WebPage00; consoleMessage: ptr ConsoleMessage00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "console-message-sent", cast[GCallback](p), xdata, nil, cf)

proc scContextMenu*(self: WebPage;  p: proc (self: ptr WebPage00; contextMenu: ptr ContextMenu00; hitTestResult: ptr WebHitTestResult00; xdata: pointer): gboolean {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "context-menu", cast[GCallback](p), xdata, nil, cf)

proc scDocumentLoaded*(self: WebPage;  p: proc (self: ptr gobject.Object00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "document-loaded", cast[GCallback](p), xdata, nil, cf)

proc scSendRequest*(self: WebPage;  p: proc (self: ptr WebPage00; request: ptr URIRequest00; redirectedResponse: ptr URIResponse00; xdata: pointer): gboolean {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "send-request", cast[GCallback](p), xdata, nil, cf)

proc scUserMessageReceived*(self: WebPage;  p: proc (self: ptr WebPage00; message: ptr UserMessage00; xdata: pointer): gboolean {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "user-message-received", cast[GCallback](p), xdata, nil, cf)

proc webkit_web_page_get_id(self: ptr WebPage00): uint64 {.
    importc, libprag.}

proc getId*(self: WebPage): uint64 =
  webkit_web_page_get_id(cast[ptr WebPage00](self.impl))

proc id*(self: WebPage): uint64 =
  webkit_web_page_get_id(cast[ptr WebPage00](self.impl))

proc webkit_web_page_get_main_frame(self: ptr WebPage00): ptr Frame00 {.
    importc, libprag.}

proc getMainFrame*(self: WebPage): Frame =
  let gobj = webkit_web_page_get_main_frame(cast[ptr WebPage00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc mainFrame*(self: WebPage): Frame =
  let gobj = webkit_web_page_get_main_frame(cast[ptr WebPage00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_web_page_get_uri(self: ptr WebPage00): cstring {.
    importc, libprag.}

proc getUri*(self: WebPage): string =
  result = $webkit_web_page_get_uri(cast[ptr WebPage00](self.impl))

proc uri*(self: WebPage): string =
  result = $webkit_web_page_get_uri(cast[ptr WebPage00](self.impl))

proc webkit_web_page_send_message_to_view(self: ptr WebPage00; message: ptr UserMessage00;
    cancellable: ptr gio.Cancellable00; callback: AsyncReadyCallback; userData: pointer) {.
    importc, libprag.}

proc sendMessageToView*(self: WebPage; message: UserMessage;
    cancellable: gio.Cancellable = nil; callback: AsyncReadyCallback; userData: pointer) =
  webkit_web_page_send_message_to_view(cast[ptr WebPage00](self.impl), cast[ptr UserMessage00](message.impl), if cancellable.isNil: nil else: cast[ptr gio.Cancellable00](cancellable.impl), callback, userData)

proc webkit_web_page_send_message_to_view_finish(self: ptr WebPage00; resu: ptr gio.AsyncResult00;
    error: ptr ptr glib.Error = nil): ptr UserMessage00 {.
    importc, libprag.}

proc sendMessageToViewFinish*(self: WebPage; resu: gio.AsyncResult): UserMessage =
  var gerror: ptr glib.Error
  let gobj = webkit_web_page_send_message_to_view_finish(cast[ptr WebPage00](self.impl), cast[ptr gio.AsyncResult00](resu.impl), addr gerror)
  if gerror != nil:
    let msg = $gerror.message
    g_error_free(gerror[])
    raise newException(GException, msg)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

type
  ScriptWorld* = ref object of gobject.Object
  ScriptWorld00* = object of gobject.Object00

proc webkit_script_world_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(ScriptWorld()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc scWindowObjectCleared*(self: ScriptWorld;  p: proc (self: ptr ScriptWorld00; page: ptr WebPage00; frame: ptr Frame00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "window-object-cleared", cast[GCallback](p), xdata, nil, cf)

proc webkit_script_world_new(): ptr ScriptWorld00 {.
    importc, libprag.}

proc newScriptWorld*(): ScriptWorld =
  let gobj = webkit_script_world_new()
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc newScriptWorld*(tdesc: typedesc): tdesc =
  assert(result is ScriptWorld)
  let gobj = webkit_script_world_new()
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc initScriptWorld*[T](result: var T) {.deprecated.} =
  assert(result is ScriptWorld)
  let gobj = webkit_script_world_new()
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_script_world_new_with_name(name: cstring): ptr ScriptWorld00 {.
    importc, libprag.}

proc newScriptWorldWithName*(name: cstring): ScriptWorld =
  let gobj = webkit_script_world_new_with_name(name)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc newScriptWorldWithName*(tdesc: typedesc; name: cstring): tdesc =
  assert(result is ScriptWorld)
  let gobj = webkit_script_world_new_with_name(name)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc initScriptWorldWithName*[T](result: var T; name: cstring) {.deprecated.} =
  assert(result is ScriptWorld)
  let gobj = webkit_script_world_new_with_name(name)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_script_world_get_default(): ptr ScriptWorld00 {.
    importc, libprag.}

proc getDefaultScriptWorld*(): ScriptWorld =
  let gobj = webkit_script_world_get_default()
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_script_world_get_name(self: ptr ScriptWorld00): cstring {.
    importc, libprag.}

proc getName*(self: ScriptWorld): string =
  result = $webkit_script_world_get_name(cast[ptr ScriptWorld00](self.impl))

proc name*(self: ScriptWorld): string =
  result = $webkit_script_world_get_name(cast[ptr ScriptWorld00](self.impl))

proc webkit_frame_get_js_context_for_script_world(self: ptr Frame00; world: ptr ScriptWorld00): ptr javascriptcore6.Context00 {.
    importc, libprag.}

proc getJsContextForScriptWorld*(self: Frame; world: ScriptWorld): javascriptcore6.Context =
  let gobj = webkit_frame_get_js_context_for_script_world(cast[ptr Frame00](self.impl), cast[ptr ScriptWorld00](world.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, javascriptcore6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_web_hit_test_result_get_js_node(self: ptr WebHitTestResult00;
    world: ptr ScriptWorld00): ptr javascriptcore6.Value00 {.
    importc, libprag.}

proc getJsNode*(self: WebHitTestResult; world: ScriptWorld = nil): javascriptcore6.Value =
  let gobj = webkit_web_hit_test_result_get_js_node(cast[ptr WebHitTestResult00](self.impl), if world.isNil: nil else: cast[ptr ScriptWorld00](world.impl))
  if gobj.isNil:
    return nil
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, javascriptcore6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

type
  WebEditor* = ref object of gobject.Object
  WebEditor00* = object of gobject.Object00

proc webkit_web_editor_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(WebEditor()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc scSelectionChanged*(self: WebEditor;  p: proc (self: ptr gobject.Object00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "selection-changed", cast[GCallback](p), xdata, nil, cf)

proc webkit_web_editor_get_page(self: ptr WebEditor00): ptr WebPage00 {.
    importc, libprag.}

proc getPage*(self: WebEditor): WebPage =
  let gobj = webkit_web_editor_get_page(cast[ptr WebEditor00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc page*(self: WebEditor): WebPage =
  let gobj = webkit_web_editor_get_page(cast[ptr WebEditor00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_web_page_get_editor(self: ptr WebPage00): ptr WebEditor00 {.
    importc, libprag.}

proc getEditor*(self: WebPage): WebEditor =
  let gobj = webkit_web_page_get_editor(cast[ptr WebPage00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc editor*(self: WebPage): WebEditor =
  let gobj = webkit_web_page_get_editor(cast[ptr WebPage00](self.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

type
  WebFormManager* = ref object of gobject.Object
  WebFormManager00* = object of gobject.Object00

proc webkit_web_form_manager_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(WebFormManager()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc scFormControlsAssociated*(self: WebFormManager;  p: proc (self: ptr WebFormManager00; frame: ptr Frame00; elements: ptr PtrArray00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "form-controls-associated", cast[GCallback](p), xdata, nil, cf)

proc scWillSendSubmitEvent*(self: WebFormManager;  p: proc (self: ptr WebFormManager00; form: ptr javascriptcore6.Value00; sourceFrame: ptr Frame00; targetFrame: ptr Frame00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "will-send-submit-event", cast[GCallback](p), xdata, nil, cf)

proc scWillSubmitForm*(self: WebFormManager;  p: proc (self: ptr WebFormManager00; form: ptr javascriptcore6.Value00; sourceFrame: ptr Frame00; targetFrame: ptr Frame00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "will-submit-form", cast[GCallback](p), xdata, nil, cf)

proc webkit_web_form_manager_input_element_auto_fill(element: ptr javascriptcore6.Value00;
    value: cstring) {.
    importc, libprag.}

proc inputElementAutoFill*(element: javascriptcore6.Value;
    value: cstring) =
  webkit_web_form_manager_input_element_auto_fill(cast[ptr javascriptcore6.Value00](element.impl), value)

proc webkit_web_form_manager_input_element_is_auto_filled(element: ptr javascriptcore6.Value00): gboolean {.
    importc, libprag.}

proc inputElementIsAutoFilled*(element: javascriptcore6.Value): bool =
  toBool(webkit_web_form_manager_input_element_is_auto_filled(cast[ptr javascriptcore6.Value00](element.impl)))

proc webkit_web_form_manager_input_element_is_user_edited(element: ptr javascriptcore6.Value00): gboolean {.
    importc, libprag.}

proc inputElementIsUserEdited*(element: javascriptcore6.Value): bool =
  toBool(webkit_web_form_manager_input_element_is_user_edited(cast[ptr javascriptcore6.Value00](element.impl)))

proc webkit_web_page_get_form_manager(self: ptr WebPage00; world: ptr ScriptWorld00): ptr WebFormManager00 {.
    importc, libprag.}

proc getFormManager*(self: WebPage; world: ScriptWorld = nil): WebFormManager =
  let gobj = webkit_web_page_get_form_manager(cast[ptr WebPage00](self.impl), if world.isNil: nil else: cast[ptr ScriptWorld00](world.impl))
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

type
  HitTestResult* = ref object of gobject.Object
  HitTestResult00* = object of gobject.Object00

proc webkit_hit_test_result_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(HitTestResult()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

type
  HitTestResultContextFlag* {.size: sizeof(cint), pure.} = enum
    ignoreThisDummyValue = 0
    document = 1
    link = 2
    image = 3
    media = 4
    editable = 5
    scrollbar = 6
    selection = 7

  HitTestResultContext* = set[HitTestResultContextFlag]

type
  UserMessageError* {.size: sizeof(cint), pure.} = enum
    userMessageUnhandledMessage = 0

type
  WebProcessExtension* = ref object of gobject.Object
  WebProcessExtension00* = object of gobject.Object00

proc webkit_web_process_extension_get_type*(): GType {.importc, libprag.}

when defined(gcDestructors):
  proc `=destroy`*(self: var typeof(WebProcessExtension()[])) =
    when defined(gintroDebug):
      echo "destroy ", $typeof(self), ' ', cast[int](unsafeaddr self)
    g_object_set_qdata(self.impl, Quark, nil)
    if not self.ignoreFinalizer and self.impl != nil:
      g_object_remove_toggle_ref(self.impl, toggleNotify, addr(self))
      self.impl = nil

proc scPageCreated*(self: WebProcessExtension;  p: proc (self: ptr WebProcessExtension00; webPage: ptr WebPage00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "page-created", cast[GCallback](p), xdata, nil, cf)

proc scUserMessageReceived*(self: WebProcessExtension;  p: proc (self: ptr WebProcessExtension00; message: ptr UserMessage00; xdata: pointer) {.cdecl.}, xdata: pointer, cf: gobject.ConnectFlags): culong =
  g_signal_connect_data(self.impl, "user-message-received", cast[GCallback](p), xdata, nil, cf)

proc webkit_web_process_extension_get_page(self: ptr WebProcessExtension00;
    pageId: uint64): ptr WebPage00 {.
    importc, libprag.}

proc getPage*(self: WebProcessExtension; pageId: uint64): WebPage =
  let gobj = webkit_web_process_extension_get_page(cast[ptr WebProcessExtension00](self.impl), pageId)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

proc webkit_web_process_extension_send_message_to_context(self: ptr WebProcessExtension00;
    message: ptr UserMessage00; cancellable: ptr gio.Cancellable00; callback: AsyncReadyCallback;
    userData: pointer) {.
    importc, libprag.}

proc sendMessageToContext*(self: WebProcessExtension;
    message: UserMessage; cancellable: gio.Cancellable = nil; callback: AsyncReadyCallback;
    userData: pointer) =
  webkit_web_process_extension_send_message_to_context(cast[ptr WebProcessExtension00](self.impl), cast[ptr UserMessage00](message.impl), if cancellable.isNil: nil else: cast[ptr gio.Cancellable00](cancellable.impl), callback, userData)

proc webkit_web_process_extension_send_message_to_context_finish(self: ptr WebProcessExtension00;
    resu: ptr gio.AsyncResult00; error: ptr ptr glib.Error = nil): ptr UserMessage00 {.
    importc, libprag.}

proc sendMessageToContextFinish*(self: WebProcessExtension;
    resu: gio.AsyncResult): UserMessage =
  var gerror: ptr glib.Error
  let gobj = webkit_web_process_extension_send_message_to_context_finish(cast[ptr WebProcessExtension00](self.impl), cast[ptr gio.AsyncResult00](resu.impl), addr gerror)
  if gerror != nil:
    let msg = $gerror.message
    g_error_free(gerror[])
    raise newException(GException, msg)
  let qdata = g_object_get_qdata(gobj, Quark)
  if qdata != nil:
    result = cast[type(result)](qdata)
    assert(result.impl == gobj)
  else:
    fnew(result, webkitwebprocessextension6.finalizeGObject)
    result.impl = gobj
    GC_ref(result)
    if g_object_is_floating(result.impl).int != 0:
      discard g_object_ref_sink(result.impl)
    g_object_add_toggle_ref(result.impl, toggleNotify, addr(result[]))
    g_object_unref(result.impl)
    assert(g_object_get_qdata(result.impl, Quark) == nil)
    g_object_set_qdata(result.impl, Quark, addr(result[]))

type
  WebProcessExtensionInitializeFunction* = proc (extension: ptr WebProcessExtension00) {.cdecl.}

type
  WebProcessExtensionInitializeWithUserDataFunction* = proc (extension: ptr WebProcessExtension00; userData: ptr glib.Variant00) {.cdecl.}
# === remaining symbols:
