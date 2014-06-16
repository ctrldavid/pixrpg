define [
  'events'
  'entities/base'
], (Events, Entity) ->

  class Attack extends Entity
    constructor: ->
      super 0, ['transform', 'graphical', 'timed']
      @component.transform.rotation = 0
      @component.transform.scale = 1

      @component.graphical.frameNumber = 0
      @component.graphical.maxFrames = 1
      @component.graphical.textureName = 'wave'

      @component.timed.ttl = 1000


  class Input extends Events
    constructor: (@entities, @canvas) ->
      @mouse = {x:0, y:0}
      @mouseHeld = {}
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
        @mouseHeld[evt.which] = true        
        @change()

      @canvas.addEventListener 'mouseup', (evt) =>
        @mouseHeld[evt.which] = false
        @change()


    change: ->
      for entity in @entities
        continue unless entity.component.input?
        keys = entity.component.input.keys
        
        if @mouseHeld[3] && entity.component.input.playerControlled
          attack = new Attack
          attack.component.transform.x = entity.component.transform.x
          attack.component.transform.y = entity.component.transform.y
          attack.component.transform.rotation = entity.component.transform.rotation + 0.5* (Math.random()-0.5)
          attack.component.transform.velocity = 3 + 3 * Math.random()
          attack.component.graphical.leavesParticles = true
          @entities.push attack

        # this is a little redundant. I may not need the locally held @held list.
        # Loop through all the keys of the entity and update their held status.
        # This lets other systems check it by using 
        # entity.component.input.held.left or entity.component.input.held.right

        for name, key of keys
          entity.component.input.held[name] = @held[key]

        #entity.component.input.held[mouse2]

        entity.component.input.mouse = @mouse

