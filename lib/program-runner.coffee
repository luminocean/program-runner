ProgramRunnerView = require './program-runner-view'
{CompositeDisposable} = require 'atom'
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

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'program-runner:run': => @run()
    @subscriptions.add atom.commands.add 'atom-workspace', 'program-runner:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @modalPanel.destroy()
    @programRunnerView.destroy()

  serialize: ->
    programRunnerViewState: @programRunnerView.serialize()

  run: ->
    @modalPanel.show() if not @modalPanel.isVisible()

    runner.runProgram (err, result) =>
      return console.err err if err?
      console.log(result)

      @programRunnerView.setContent result

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
