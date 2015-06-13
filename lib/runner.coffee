#This module contains the main logic of the program-runner

cp = require 'child_process'
path = require 'path'
config = require './config'

module.exports = runner =
  # Run the program from the source code which is being edited
  runProgram: (callback) ->
    filePath = atom.workspace.getActiveTextEditor()?.getPath()
    return console.error "Invalid path: #{filePath}" if not filePath?

    extension = path.extname filePath
    langConfig = lookupConfig extension
    return console.error("No config for the extension type #{extension}") if not langConfig?

    # Go executing the program
    cp.exec "#{langConfig.command} #{langConfig.flags ? ''} #{filePath}", (err, stdout, stderr)->
      return callback err if err?
      callback null,stdout

# lookup execution config based on the given extension
lookupConfig = (extension) ->
  languages = config.languages
  for lang in languages
    ext = lang.extension
    if ext == extension
      return lang
