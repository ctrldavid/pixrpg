define [
], () ->

  class Timed
    constructor: ->
      @birth = new Date
      @ttl = 1000

    expired: ->
      new Date - @birth > @ttl
