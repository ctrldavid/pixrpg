define [
  'events'
], (Events) ->


  class Input extends Events
    constructor: (@entities, @canvas) ->
      @mouse = {x:0, y:0}
      @buttons = {}
      @held = {}

      document.addEventListener 'keydown', (evt) =>
        pressed = evt.keyCode
        console.log pressed
        @held[pressed] = true
        #@trigger "key-#{pressed}"
        @change()

      document.addEventListener 'keyup', (evt) =>
        pressed = evt.keyCode
        @held[pressed] = false
        @change()

      @canvas.addEventListener 'mousemove', (evt) =>
        @mouse.x = evt.clientX
        @mouse.y = evt.clientY
        @change()

      @canvas.addEventListener 'contextmenu', (evt) =>
        console.log evt
        evt.preventDefault()

      @canvas.addEventListener 'mousedown', (evt) =>
        console.log evt.which
        @change()

      @canvas.addEventListener 'mouseup', (evt) =>
        console.log evt.which
        @change()


    change: ->
      for entity in @entities
        continue unless entity.component.input?
        keys = entity.component.input.keys
        
        # this is a little redundant. I may not need the locally held @held list.
        # Loop through all the keys of the entity and update their held status.
        # This lets other systems check it by using 
        # entity.component.input.held.left or entity.component.input.held.right

        for name, key of keys
          entity.component.input.held[name] = @held[key]

        entity.component.input.mouse = @mouse

