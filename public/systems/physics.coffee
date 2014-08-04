define [
  'events'
], (Events) ->



  class Physics
    constructor: (@entities) ->
      @tick()

    tick: =>
      for entityID, entity of @entities.hashmap
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
          spark = @entities.create @entities.blueprint.spark
          spark.component.transform.x = entity.component.transform.x+ 15 * (Math.random() - 0.5)
          spark.component.transform.y = entity.component.transform.y+ 15 * (Math.random() - 0.5)
          spark.component.transform.rotation = entity.component.transform.rotation + 0.2 * (Math.random() - 0.5)
          spark.component.transform.velocity = entity.component.transform.velocity * Math.random()

        #walk formward slowly
        entity.component.transform.x -= entity.component.transform.velocity * Math.cos(entity.component.transform.rotation)
        entity.component.transform.y -= entity.component.transform.velocity * Math.sin(entity.component.transform.rotation)

        if entity.component.timed? && entity.component.timed.expired()
          @entities.remove entity
         
      window.setTimeout @tick, 15