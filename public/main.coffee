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
      @game = new Game @canvas

      window.addEventListener 'resize', => @game.resetDimensions()
      window.setTimeout => 
        @game.resetDimensions()
      , 500


  new PixRPGApp


