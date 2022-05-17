# ldc

loading js component/action framework.


## API

 - `ldc.register(name, dep-list, (({dep-list}) ->))`: register a component
   - while name ignored the module will be an anonymous module and be treated as an app directly.
   - return the registered ldc object.
 - `ldc.app(name, ...)`: set main entry point of component
 - `ldc.init(opt, ...)`: force init components
   - `opt` is either:
     - a string: name for specific ldc component.
     - an object: a ldc object ( returned by `ldc.register` )
     - an array of either string or objects as above
 - `ldc.on(name, ((...opts)->)`: listen to a ldc event
 - `ldc.fire(name, ...opts)`: fire a ldc event
 - `ldc.action(opt1, opt2)`: register an action handler.
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


A newly created this context can be used in this module:

    ldc.regsiter "module1", <[]>, -> return @ <<< {foo: -> \bar}


Declare dependency and load another module:

    ldc.regsiter "module2", <[module1]>, ({module1}) ->


the `module1` object sent to module2 handler will be the returned value in the module1 handler:

    ldc.regsiter "module2", <[module1]>, ({module1}) ->
      assert module1.foo! == \bar

Each module function will be called at most once. The returned object in the first call will be used then.

    ldc.regsiter "module1", <[]>, ->
      console.log "this line runs only once."
      @foo = (@foo or 0) + 1
      return @
    ldc.regsiter "module2", <[module1]>, ({module1}) ->
      assert module.foo == 1
    ldc.regsiter "module3", <[module1]>, ({module1}) ->
      assert module.foo == 1


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
