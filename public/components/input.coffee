define [
], () ->

  class Input
    constructor: ->
      @mouse = {x:0, y:0}
      @keys = {}
      @held = {}
      @pressed = {}
      ### Example 
      @keys = {
        up: 38
        down: 40
        left: 37
        right: 39
      }

      As input thing runs, @held and @pressed will change.
      @held.up = true || false
      @pressed.up = 0 ... infinity (how many times it was pressed since last clearning.)
      ###

      @playerControlled = false