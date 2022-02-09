local = {}
window.lda = lda = {}
window.ldc = ldc = do
  module: {}
  # n: module name. if omitted, register an anonymous module as main module.
  # d: module dependency. array of strings.
  # f: module function({modules},{params}). should always return module object.
  register: (n, d, f) -> if Array.isArray(n) => @apps.push({f: d, d: n}) else @module[n] = {f, d}
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
  init: (names) ->
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
    for k in (names or @apps) => _(k)
  run: (name) ->
    @init if Array.isArray(name) => name else [name]
    return null
      
window.addEventListener \DOMContentLoaded, -> ldc.init!
