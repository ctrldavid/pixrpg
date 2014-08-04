define [
  'events'
  'components/transform'
  'components/input'
  'components/graphical' 
  'components/timed' 
], (Events, Transform, Input, Graphical, Timed) -> 

  components = {
    'transform': Transform
    'input': Input
    'graphical': Graphical
    'timed': Timed
  }

  class EntityBaseClass
    constructor: (@id, componentList) ->
      # @id = undefined
      @component = {}
      # @component[component] = new components[component] for component in componentList

  ###
    Going to try make the `entities` list slightly smarter than just an array.
    Will use a hashmap to make insertions and deletions easier, and also pass 
    them through a method so I can do things like batching them later.
  ###

  class EntityList
    blueprint:
      player:
        transform:
          x: -> Math.random() * 2000
          y: -> Math.random() * 800
          scale: 2
        graphical:
          maxFrames: 4
          textureName: 'walk'
          frameTime: 50
        input:
          keys:
            up: 69
            down: 68
            left: 83
            right: 70
          playerControlled: true    
      attack:
        transform:
          scale: 1
        graphical:
          maxFrames: 1
          textureName: 'wave'
          leavesParticles: true
        timed:
          ttl: 1000
      spark:
        transform:
          scale: 1
        graphical:
          maxFrames: 4
          frameTime: 100
          frameLoop: false
          textureName: 'wavestream'
        timed:
          ttl: 400
      bullet:
        transform:
          scale: 1
        graphical:
          maxFrames: 1
          textureName: 'bullet'
        timed:
          ttl: 3000          

    constructor: ->
      @hashmap = {}
      @idctr = 0
    newID: -> "ghetto-client-id-#{@idctr++}"
    add: (entity) ->
      entity.id = @newID() unless entity.id?
      @hashmap[entity.id] = entity
    create: (blueprint, id) ->
      console.log 'creating', id
      entity = new EntityBaseClass id
      @expandBlueprint entity, blueprint
      @add entity
      return entity

    expandBlueprint: (entity, blueprint) ->
      for componentName, componentBlueprint of blueprint
        component = new components[componentName]
        for field, value of componentBlueprint
          component[field] = if typeof value == "function" then value() else value
        entity.component[componentName] = component

    remove: (entity) ->
      delete @hashmap[entity.id]

  return EntityList