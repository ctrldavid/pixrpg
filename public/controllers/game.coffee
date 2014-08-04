define [
  'controller'
  'entities/base'
  'systems/canvas_draw'
  'systems/input'
  'systems/physics'
  'systems/network'
], (Controller, EntityList, CanvasDrawSystem, InputSystem, PhysicsSystem, NetworkSystem) ->

  class Game# extends Controller
    constructor: (@canvas) ->
      @entities = new EntityList
      window.e = @entities

      # Don't need anymore, player is created on the server
      # @entities.create @entities.blueprint.player


      @canvasDrawSystem = new CanvasDrawSystem @entities, @canvas
      @inputSystem = new InputSystem @entities, @canvas
      @physicsSystem = new PhysicsSystem @entities
      @networkSystem = new NetworkSystem @entities


    resetDimensions: ->
      console.log 'resizing to', @canvas.clientWidth, @canvas.clientHeight
      @canvas.width = @canvas.clientWidth
      @canvas.height = @canvas.clientHeight      

  return Game

