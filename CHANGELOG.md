# Change Logs

## v0.0.6

 - reverse `0.0.5` code for code order issue since it's not a valid solution


## v0.0.5

 - upgrade dependencies for vulnerability fixing
 - update auto init code to prevent from missing events issue caused by code order or readystate hijack by frameworks such as Cloudflare.
   - see [this post](https://community.cloudflare.com/t/domcontentloaded-event-is-missing-when-rocket-loader-is-enabled/393337`) for more information.


## v0.0.4

 - call modules with a brand new this object.
 - `register` returns the registered ldc object
 - accept object or list in `init`.


## v0.0.3

 - rename `ldc.js`, `ldc.min.js` to `index.js` and `index.min.js`
 - upgrade modules
 - add `main` and `browser` field in `package.json`.
 - further minimize generated js file with mangling and compression
 - remove assets files from git
 - patch test code to make it work with upgraded modules
 - release with compact directory structure


## v0.0.2

 - update module name to `@loadingio/ldc`
 - upgrade dependencies
