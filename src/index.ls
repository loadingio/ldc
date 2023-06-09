local = {}
window.lda = lda = {}
window.ldc = ldc = do
  module: {}
  # n: module name. if omitted, register an anonymous module as main module.
  # d: module dependency. array of strings.
  # f: module function({modules},{params}). should always return module object.
  register: (n, d, f) ->
    if Array.isArray(n) => @apps.push(ret = {f: d, d: n})
    else ret = @module[n] = {f, d}
    ret
  evt-handler: {}
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v
  act-handler: {}
  action: (n, cb) ->
    if typeof(n) == \object =>
      if !local.name =>
        console.warn "ldc.action(): Action registered after module initialization will be anonymous actions."
        console.warn "You can name the action set explicitly if you have to do this."
        console.warn "e.g., ldc.action('name', { actions ... });"
        console.warn "related action object: ", n
      if local.name => lda[local.name] = n
    else if typeof(cb) == \object => lda[n] = cb
    else @act-handler.[][n].push cb
  act: (n, ...v) -> for cb in (@act-handler[n] or []) => cb.apply @, v
  apps: []
  app: (...args) -> @apps ++= args
  init: (ns) ->
    # this is used only for controlling auto init below.
    local._inited = true
    _ = (param) ~>
      [p,name,m] = if typeof(param) == \object => [{},"",param] else [{},param, @module[param]]
      if !m => return null
      if m.o => return m.o
      if m.state == \initing => throw new Error("circular dependency")
      m.state = \initing
      for n in m.d => p[n] = _(n)
      m.state = \inited
      local.name = name
      m.o = m.f.call (m._o = {}), p
      local.name = null
      return m.o
    ns = if !ns => @apps else if Array.isArray(ns) => ns else [ns]
    for k in ns => _ k
  run: (n) -> @init n; return null

# sometimes it's possible that readystate is complete before we reach here.
# we need the ldc.init called no earlier than DOMContentLoaded, so `interactive` is not reliable.
if document.readyState in <[complete loaded]> => ldc.init!
else
  # and sometimes DOMContentLoaded may not be fired.
  # such as, when using cloudflare Rocket Launcher
  # thus, we wait both for readystate update and DOMContentLoaded
  document.addEventListener \readystatechange, ->
    # based on https://stackoverflow.com/questions/13346746/document-readystate-on-domcontentloaded
    # it may be `loaded` too
    if (document.readyState in <[complete loaded]>) and !local._inited => ldc.init!
  document.addEventListener \DOMContentLoaded, -> if !local._inited => ldc.init!
