define [
], () ->

  class Graphical
    constructor: ->
      @frameNumber = 0
      @maxFrames = 0
      @textureName = undefined
      @lastFrame = new Date
      @frameTime = 30
      @frameLoop = true

    nextFrame: ->
      if @frameLoop
        @frameNumber = (@frameNumber + 1) % @maxFrames
      else
        @frameNumber = (@frameNumber + 1) unless @frameNumber == @maxFrames - 1
