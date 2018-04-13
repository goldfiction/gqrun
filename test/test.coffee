run=require '../index.js'

# pass in your script as script property
run.run {script:"
console.log(123);
console.log(123);
console.log(123);
console.log(123/0);
throw new Error('An error occurred');
"},(e,o)->
  console.log o.log    # console.log will output here