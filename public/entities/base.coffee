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
      @id = undefined
      @component = {}
      @component[component] = new components[component] for component in componentList