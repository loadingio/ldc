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

# DOMContentLoaded may be fired before this, if script are dynamically re-injected
# by external scripts such as Rocket Launcher.
# in this case, it doesn't help even if we check `readyState`
# since `ldc` expects to be loaded first but init after all scripts are ready -
# however `readyState` will always be complete if this code is parsed after complete.
# in this case, user has to call `ldc.init` and trigger `DOMContentLoaded`
# manually in the end of injected script.
document.addEventListener \DOMContentLoaded, -> ldc.init!
