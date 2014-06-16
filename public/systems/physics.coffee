define [
  'events'
  'entities/base'
], (Events, Entity) ->

  class Spark extends Entity
    constructor: ->
      super 0, ['transform', 'graphical', 'timed']
      @component.transform.rotation = 0
      @component.transform.scale = 1

      @component.graphical.frameNumber = 0
      @component.graphical.maxFrames = 4
      @component.graphical.frameTime = 100
      @component.graphical.frameLoop = false
      @component.graphical.textureName = 'wavestream'

      @component.timed.ttl = 400

  class Physics
    constructor: (@entities) ->
      @tick()

    tick: =>
      for entity in @entities
        if entity.component.input?.playerControlled
          entity.component.transform.facePoint entity.component.input.mouse.x, entity.component.input.mouse.y

          if entity.component.input.held.up
            entity.component.transform.y--
          if entity.component.input.held.down
            entity.component.transform.y++
          if entity.component.input.held.left
            entity.component.transform.x--
          if entity.component.input.held.right
            entity.component.transform.x++


        
        if entity.component.graphical.leavesParticles
          spark = new Spark
          spark.component.transform.x = entity.component.transform.x+ 15 * (Math.random() - 0.5)
          spark.component.transform.y = entity.component.transform.y+ 15 * (Math.random() - 0.5)
          spark.component.transform.rotation = entity.component.transform.rotation + 0.2 * (Math.random() - 0.5)
          spark.component.transform.velocity = entity.component.transform.velocity * Math.random()
          @entities.push spark

        #walk formward slowly
        entity.component.transform.x -= entity.component.transform.velocity * Math.cos(entity.component.transform.rotation)
        entity.component.transform.y -= entity.component.transform.velocity * Math.sin(entity.component.transform.rotation)
      
      count = @entities.length
      for index in [0...count]
        entity = @entities[index]
        if entity.component.timed? && entity.component.timed.expired()
          @entities.splice index, 1
          index--
          count--
          
      window.setTimeout @tick, 30