define [
  'events'
], (Events, Entity) ->

  class Input extends Events
    constructor: (@entities, @canvas) ->
      @mouse = {x:0, y:0}
      @mouseHeld = {}
      @held = {}

      document.addEventListener 'keydown', (evt) =>
        pressed = evt.keyCode
        # console.log pressed
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
        # console.log evt
        evt.preventDefault()

      @canvas.addEventListener 'mousedown', (evt) =>
        @mouseHeld[evt.which] = true        
        @change()

      @canvas.addEventListener 'mouseup', (evt) =>
        @mouseHeld[evt.which] = false
        @change()

      @update()  # gross but needed for held repeats?


    change: ->
      for entityID, entity of @entities.hashmap
        continue unless entity.component.input?
        keys = entity.component.input.keys
    
        # this is a little redundant. I may not need the locally held @held list.
        # Loop through all the keys of the entity and update their held status.
        # This lets other systems check it by using 
        # entity.component.input.held.left or entity.component.input.held.right

        for name, key of keys
          entity.component.input.held[name] = @held[key]

        #entity.component.input.held[mouse2]

        entity.component.input.mouse = @mouse

    update: =>
      for entityID, entity of @entities.hashmap
        continue unless entity.component.input?
        if @mouseHeld[3] && entity.component.input.playerControlled
          #attack = @entities.create @entities.blueprint.attack
          attack = @entities.create @entities.blueprint.bullet
          attack.component.transform.x = entity.component.transform.x
          attack.component.transform.y = entity.component.transform.y
          attack.component.transform.rotation = entity.component.transform.rotation + 0.05* (Math.random()-0.5)
          attack.component.transform.velocity = 3

      setTimeout @update, 100
