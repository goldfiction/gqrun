run=require '../index.js'
fs=require 'fs'
assert=require 'assert'

describe "test methods",()->
  it "should be able to run string scripts",(done)->
    # pass in your script as script property
    run.run {text:fs.readFileSync("test/testapp.txt").toString()},(e,o)->
      console.log o.log    # console.log will output here
      assert.equal o.log.includes("Error: An error occurred"),1
      done null
  it "should be able to run cmd",(done)->
    run.runCMD
      cmd:"ls"
      parameter:['..']
      log:(data)->
        console.log data+''
      ,(e,o)->
        console.log o
        done e