// Generated by CoffeeScript 1.12.7
(function() {
  var _, endOfLine, vm;

  vm = require("vm");

  _ = require('lodash');

  endOfLine = require('os').EOL;

  exports.run = function(o, cb) {
    var Log, context, e, err, log;
    o = o || {};
    o.options = o.options || {};
    o.options.displayErrors = false;
    Log = "";
    log = o.log || function(obj) {
      if (obj) {
        if (typeof obj === "string") {
          return Log += endOfLine + obj;
        } else if (typeof obj === "object") {
          return Log += endOfLine + JSON.stringify(obj, null, 2);
        } else {
          return Log += endOfLine + obj + '';
        }
      }
    };
    o.text = o.text || "";
    o.context = o.context || {};
    context = {
      log: log,
      console: {
        log: log
      },
      process: {
        stdout: {
          write: log
        },
        stderr: {
          write: log
        }
      }
    };
    o.context = _.extend(context, o.context);
    err = null;
    try {
      vm.runInNewContext(o.text, o.context, o.options);
    } catch (error) {
      e = error;
      log(e.stack);
      err = e;
    }
    o.log = Log;
    return cb(err, o);
  };

  exports.runCMD = function(o, cb) {
    var child, spawn;
    o = o || {};
    o.cmd = o.cmd || "";
    o.parameter = o.parameter || [];
    o.log = o.log || console.log;
    o.message = o.message || "";
    spawn = require('child_process').spawn;
    child = spawn(o.cmd, o.parameter);
    child.stdout.on('data', function(chunk) {
      o.log(chunk + '');
      return o.message += chunk + '';
    });
    child.stderr.on('data', function(chunk) {
      o.log(chunk + '');
      return o.message += chunk + '';
    });
    child.on('close', (function(_this) {
      return function(code) {
        o.code = code;
        return cb(null, o);
      };
    })(this));
    return child.on('error', (function(_this) {
      return function(err) {
        o.error = err;
        return cb(err, o);
      };
    })(this));
  };

}).call(this);
