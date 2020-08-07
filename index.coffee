vm = require "vm"
_=require 'lodash'
endOfLine = require('os').EOL

exports.run=(o,cb)->
  o=o||{}
  o.options=o.options||{}
  o.options.displayErrors=false

  Log=""

  log=o.log||(obj)->
    if(obj)
      if typeof obj=="string"
        Log+=endOfLine+obj
      else if typeof obj=="object"
        Log+=endOfLine+JSON.stringify(obj,null,2)
      else
        Log+=endOfLine+obj+''

  o.text=o.text||""
  o.context=o.context||{}
  context={log:log,console:{log:log},process:{stdout:{write:log},stderr:{write:log}}}
  o.context=_.extend(context,o.context)
  err=null

  try
    vm.runInNewContext(o.text, o.context, o.options)
  catch e
    log e.stack
    err=e

  o.log=Log
  cb(err,o)

exports.runCMD=(o,cb)->
  o=o||{}
  o.cmd=o.cmd||""
  o.parameter=o.parameter||[]
  o.log=o.log||console.log
  o.message=o.message||""
  spawn = require('child_process').spawn
  child = spawn o.cmd, o.parameter
  child.stdout.on 'data', (chunk)->
    o.log chunk+''
    o.message+=chunk+''
  child.stderr.on 'data', (chunk)->
    o.log chunk+''
    o.message+=chunk+''
  child.on 'close', (code) =>
    o.code=code
    cb null,o
  child.on 'error', (err) =>
    o.error=err
    cb err,o