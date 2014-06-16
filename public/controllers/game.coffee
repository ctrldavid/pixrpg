define [
  'components/transform'
  'components/input'
  'components/graphical'
  'systems/canvas_draw'
  'systems/input'
  'systems/physics'
], (Transform, Input, Graphical, CanvasDrawSystem, InputSystem, PhysicsSystem) ->

  components = {
    'transform': Transform
    'input': Input
    'graphical': Graphical
  }

  class Entity
    constructor: (@id, componentList) ->
      @id = undefined
      @component = {}
      @component[component] = new components[component] for component in componentList

  class Player extends Entity
    constructor: ->
      super 0, ['transform', 'input', 'graphical']
      @component.transform.x = Math.random() * 2000
      @component.transform.y = Math.random() * 800
      @component.transform.rotation = 0
      @component.transform.scale = 1
      

      @component.graphical.frameNumber = 0
      @component.graphical.maxFrames = 4
      @component.graphical.textureName = 'walk'

      @component.input.keys = {
        up: 69
        down: 68
        left: 83
        right: 70
      }


  class Game
    constructor: (@canvas) ->
      @entities = []
      window.e = @entities

      player = new Entity 0, ['transform', 'input', 'graphical']
      player.component.transform.x = @canvas.width/3
      player.component.transform.y = @canvas.height/3
      player.component.transform.rotation = 0
      player.component.transform.scale = 1
      

      player.component.graphical.frameNumber = 0
      player.component.graphical.maxFrames = 4
      player.component.graphical.textureName = 'walk'

      player.component.input.keys = {
        up: 69
        down: 68
        left: 83
        right: 70
      }
      
      @entities.push player


      # player = new Entity 0, ['transform', 'input', 'graphical']
      # player.component.transform.x = @canvas.width/2
      # player.component.transform.y = @canvas.height/2
      # player.component.transform.rotation = 0
      # player.component.transform.scale = 1

      # player.component.graphical.frameNumber = 0
      # player.component.graphical.maxFrames = 4
      # player.component.graphical.textureName = 'walk'
      # player.component.graphical.frameTime = 40


      # player.component.input.keys = {
      #   up: 38
      #   down: 40
      #   left: 37
      #   right: 39
      # }      


      # @entities.push player

      # for i in [0...1000]
      #   @entities.push new Player

      @canvasDrawSystem = new CanvasDrawSystem @entities, @canvas
      @inputSystem = new InputSystem @entities, @canvas
      @physicsSystem = new PhysicsSystem @entities


    resetDimensions: ->
      console.log 'resizing to', @canvas.clientWidth, @canvas.clientHeight
      @canvas.width = @canvas.clientWidth
      @canvas.height = @canvas.clientHeight      



  return Game

