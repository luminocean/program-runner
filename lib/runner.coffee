#This module contains the main logic of the program-runner

cp = require 'child_process'

module.exports = runner =
  runProgram: (callback)->
    console.log 'Running program...'
    filePath = atom.workspace.getActiveTextEditor()?.getPath()

    if not filePath?
      console.log "Invalid path: #{filePath}"
      return

    cp.exec "coffee #{filePath}", (err, stdout, stderr)->
      return callback err if err?
      callback null,stdout
