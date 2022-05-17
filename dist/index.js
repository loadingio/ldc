(function(){
  var local, lda, ldc;
  local = {};
  window.lda = lda = {};
  window.ldc = ldc = {
    module: {},
    register: function(n, d, f){
      var ret;
      if (Array.isArray(n)) {
        this.apps.push(ret = {
          f: d,
          d: n
        });
      } else {
        ret = this.module[n] = {
          f: f,
          d: d
        };
      }
      return ret;
    },
    evtHandler: {},
    on: function(n, cb){
      var ref$;
      return ((ref$ = this.evtHandler)[n] || (ref$[n] = [])).push(cb);
    },
    fire: function(n){
      var v, res$, i$, to$, ref$, len$, cb, results$ = [];
      res$ = [];
      for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      v = res$;
      for (i$ = 0, len$ = (ref$ = this.evtHandler[n] || []).length; i$ < len$; ++i$) {
        cb = ref$[i$];
        results$.push(cb.apply(this, v));
      }
      return results$;
    },
    actHandler: {},
    action: function(n, cb){
      var ref$;
      if (typeof n === 'object') {
        if (!local.name) {
          console.warn("ldc.action(): Action registered after module initialization will be anonymous actions.");
          console.warn("You can name the action set explicitly if you have to do this.");
          console.warn("e.g., ldc.action('name', { actions ... });");
          console.warn("related action object: ", n);
        }
        if (local.name) {
          return lda[local.name] = n;
        }
      } else if (typeof cb === 'object') {
        return lda[n] = cb;
      } else {
        return ((ref$ = this.actHandler)[n] || (ref$[n] = [])).push(cb);
      }
    },
    act: function(n){
      var v, res$, i$, to$, ref$, len$, cb, results$ = [];
      res$ = [];
      for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      v = res$;
      for (i$ = 0, len$ = (ref$ = this.actHandler[n] || []).length; i$ < len$; ++i$) {
        cb = ref$[i$];
        results$.push(cb.apply(this, v));
      }
      return results$;
    },
    apps: [],
    app: function(){
      var args, res$, i$, to$;
      res$ = [];
      for (i$ = 0, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      args = res$;
      return this.apps = this.apps.concat(args);
    },
    init: function(ns){
      var _, i$, len$, k, this$ = this, results$ = [];
      _ = function(param){
        var ref$, p, name, m, i$, len$, n;
        ref$ = typeof param === 'object'
          ? [{}, "", param]
          : [{}, param, this$.module[param]], p = ref$[0], name = ref$[1], m = ref$[2];
        if (!m) {
          return null;
        }
        if (m.o) {
          return m.o;
        }
        if (m.state === 'initing') {
          throw new Error("circular dependency");
        }
        m.state = 'initing';
        for (i$ = 0, len$ = (ref$ = m.d).length; i$ < len$; ++i$) {
          n = ref$[i$];
          p[n] = _(n);
        }
        m.state = 'inited';
        local.name = name;
        m.o = m.f.call(m._o = {}, p);
        local.name = null;
        return m.o;
      };
      ns = !ns
        ? this.apps
        : Array.isArray(ns)
          ? ns
          : [ns];
      for (i$ = 0, len$ = ns.length; i$ < len$; ++i$) {
        k = ns[i$];
        results$.push(_(k));
      }
      return results$;
    },
    run: function(n){
      this.init(n);
      return null;
    }
  };
  window.addEventListener('DOMContentLoaded', function(){
    return ldc.init();
  });
}).call(this);
