# ldc

loading js component/action framework.


## API

 * ldc.register(name, dep-list, (({dep-list}) ->)) - register a component
   - while name ignored the module will be an anonymous module and be treated as an app directly.
 * ldc.app(name-list) - set main entry point of component
 * ldc.init(name-list) - force init certain components
 * ldc.on(name, ((...opts)->) - listen to a ldc event
 * ldc.fire(name, ...opts) - fire a ldc event
 * ldc.action(opt1, opt2) - register an action handler.
   there are three different cases of usage
   1. opt1 = name, opt2 = object
      register an set of action handler under the namespace with opt1 as its name.

   2. opt1 = object, opt2 is omitted
      similar to 1. while use module name as the action name.
     
   3. opt1 = name, opt2 = function (deprecated)
      register ldc action. deprecated since we can use on/fire to replace this.


## Module

ldc helps us to maintain the dependency of modules. Define a module as follow:

    ldc.regsiter "module1", <[]>, -> return {foo: -> \bar}


declare dependency and load another module:

    ldc.regsiter "module2", <[module1]>, ({module1}) ->


the `module1` object sent to module2 handler will be the returned value in the module1 handler:

    ldc.regsiter "module2", <[module1]>, ({module1}) ->
      assert module1.foo! == \bar


main entry module can be defined by `ldc.app` or by omitting the module name:

    ldc.regsiter <[module1 module2]>, ({module1, module2}) -> ...


## Action

One can use `lda` to access the actions registered via `ldc.action`. For example, following code registers a set of actions:

    ldc.register "mymodule", [], ->
      ldc.action do
        open: ->
        close: ->


Once registered, we can use `ldc.mymodule` to access them:

    ldc.mymodule.open!


## License

MIT
