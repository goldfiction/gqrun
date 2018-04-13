vm = require "vm"
_=require 'lodash'

exports.run=(o,cb)->
  o=o||{}
  o.options=o.options||{}
  o.options.displayErrors=false

  Log=""

  log=(obj)->
    if(obj)
      if typeof obj=="string"
        Log+='\n'+obj
      else if typeof obj=="object"
        Log+='\n'+JSON.stringify(obj,null,2)
      else
        Log+='\n'+obj+''

  o.script=o.script||""
  o.context=o.context||{}
  context={log:log,console:{log:log},process:{stdout:{write:log},stderr:{write:log}}}
  o.context=_.extend(context,o.context)
  err=null

  try
    vm.runInNewContext(o.script, o.context, o.options)
  catch e
    log JSON.stringify(e.stack,null,2)
    err=e

  o.log=Log
  cb(err,o)

