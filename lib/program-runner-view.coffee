module.exports =
class ProgramRunnerView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('program-runner')

    # Create output element
    output = document.createElement('textArea')
    output.readonly = true
    output.rows = 8

    output.classList.add('output')
    @element.appendChild(output)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setContent: (content) ->
    output = document.getElementsByClassName('output')?[0]
    output.textContent = content if output?
