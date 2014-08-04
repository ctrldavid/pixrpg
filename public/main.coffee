define [
  '$'
  'view'
  'application'
  'templates/layout'
  'controllers/game'
], ($, View, Application, layoutT, Game) ->

  class PixRPGApp extends Application
    template: layoutT
    render: ->

    rendered: ->
      @canvas = @$el.find('.js-canvas')[0]

    appeared: ->
      window.setTimeout =>
        @canvas.width = @canvas.clientWidth
        @canvas.height = @canvas.clientHeight            
        @game = new Game @canvas
        window.game = @game
        window.addEventListener 'resize', => @game.resetDimensions()

      , 500


  new PixRPGApp


