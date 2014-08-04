define [
  'controller'
], (Controller) ->



  class Network extends Controller
    channels: 
      pixrpg:
        update: (data) ->
          #console.groupCollapsed "Network Update (#{data.length})"
          for entity in data
            #console.log entity.id, JSON.stringify entity.components
            continue if @entities.hashmap[entity.id].component.input?.playerControlled
            @entities.hashmap[entity.id].component.transform.x = entity.components.transform.x
            @entities.hashmap[entity.id].component.transform.y = entity.components.transform.y
            @entities.hashmap[entity.id].component.transform.rotation = entity.components.transform.rotation
          #console.groupEnd()

        create: (data) ->
          #console.groupCollapsed "Network Create (#{data.length})"
          for entity in data
            @entities.create entity.components, entity.id
            #console.log entity.id, JSON.stringify entity.components
          #console.groupEnd()


    constructor: (@entities) ->      
      super
      # should probably start this later in response to an event.
      @tick()

    init: ->
      # No games yet, just a plain join message to start
      @send 'pixrpg', 'join'

    tick: =>
      updatePacket = []
      for entityID, entity of @entities.hashmap
        if entity.component.input?.playerControlled
          updatePacket.push entity
      @send 'pixrpg', 'update', updatePacket

      setTimeout @tick, 100