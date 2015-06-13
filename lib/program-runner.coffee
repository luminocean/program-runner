# Package Entry Module

ProgramRunnerView = require './program-runner-view'
{CompositeDisposable} = require 'atom'

# Logic Module
runner = require './runner'

module.exports = ProgramRunner =
  programRunnerView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @programRunnerView = new ProgramRunnerView(state.programRunnerViewState)
    @modalPanel = atom.workspace.addBottomPanel(item: @programRunnerView.getElement(), visible:false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands and get ready for later disposal
    @subscriptions.add atom.commands.add 'atom-workspace', 'program-runner:run': => @run()
    @subscriptions.add atom.commands.add 'atom-workspace', 'program-runner:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @modalPanel.destroy()
    @programRunnerView.destroy()

  serialize: ->
    programRunnerViewState: @programRunnerView.serialize()

  #### Customized methods from below ####

  # Toggle the panel
  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  # Run the code being edited
  # Compile it first if needed
  run: ->
    runner.runProgram (err, result) =>
      return console.err err if err?

      @programRunnerView.setContent result
      @modalPanel.show() if not @modalPanel.isVisible()
