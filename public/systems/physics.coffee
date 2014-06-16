define [
  'events'
], (Events) ->

  class Physics
    constructor: (@entities) ->
      @tick()

    tick: =>
      for entity in @entities
        entity.component.transform.facePoint entity.component.input.mouse.x, entity.component.input.mouse.y

        if entity.component.input.held.up
          entity.component.transform.y--
        if entity.component.input.held.down
          entity.component.transform.y++
        if entity.component.input.held.left
          entity.component.transform.x--
        if entity.component.input.held.right
          entity.component.transform.x++


        #walk formward slowly
        entity.component.transform.x -= 0.5 * Math.cos(entity.component.transform.rotation)
        entity.component.transform.y -= 0.5 * Math.sin(entity.component.transform.rotation)

      window.setTimeout @tick, 15