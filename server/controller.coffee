uuid = require 'node-uuid'

# Gross
playerBP =
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

expandBlueprint = (entity, blueprint) ->
  for componentName, componentBlueprint of blueprint
    #component = new components[componentName]
    component = {}
    for field, value of componentBlueprint
      component[field] = if typeof value == "function" then value() else value
    entity.components[componentName] = component

class Component

class Transform extends Component
  constructor: ->
    @x = 0
    @y = 0

class Entity
  constructor: ->
    @id = uuid.v4()
    @components = {}

class EntityList
  constructor: ->
    @map = {}

  add: (entity) ->
    @map[entity.id] = entity
  remove: (entity) ->
    delete @map[entity.id]

class PlayerEntity extends Entity
  constructor: (@client) ->
    super
    expandBlueprint this, playerBP
    
    


class Game
  constructor: (@id) ->
    @entities = new EntityList
    # entity id -> entity mapping. Used to get the clients for updates. 
    # probably the wrong way to do it but easy enough to refactor
    @players = {} 

  playerJoin: (client) ->
    player = new PlayerEntity client

    @entities.add player
    @players[player.id] = player

    # ghetto, move it somewhere else
    # send all entities to new player
    player.components.input.playerControlled = true
    updatePacket = []
    for id, entity of @entities.map
      updatePacket.push {id, components:entity.components}

    player.client.reply.send 'pixrpg', {command: 'create', data: updatePacket}

    player.components.input.playerControlled = false


    # send new player entity to existing players
    updatePacket = [{id: player.id, components: player.components}]

    for id, player2 of @players
      continue if id == player.id
      player2.client.reply.send 'pixrpg', {command: 'create', data: updatePacket}



  playerLeave: (client) ->
    (player = p if p.client.connectionid == client.connectionid) for id, p of @players
    
    return unless player?
    delete @players[player.id]
    @entities.remove player

  updateTick: ->
    # here is where we would use the priority thing to limit the size of the updates
    # and limit it to entities in view and shit (so they can't cheat and see hidden
    # units or shrines or whatever.)
    # for now though just send everything.
    #updatePacket = @entities.map # update all the things.
    updatePacket = []
    for id, entity of @entities.map
      updatePacket.push {id, components:entity.components}

    for id, player of @players
      player.client.reply.send 'pixrpg', {command: 'update', data: updatePacket}

  update: (entities) ->
    for entity in entities
      continue unless @entities.map[entity.id]?     
      @entities.map[entity.id].components.transform.x = entity.component.transform.x
      @entities.map[entity.id].components.transform.y = entity.component.transform.y



class GameList
  constructor: ->
    @games = {}

  new: ->
    newgameID = uuid.v4()
    @games[newgameID] = new Game newgameID
    return @games[newgameID]



exports.load = (Controller, {Reply}) ->
  class PixrpgController extends Controller
    init: ->
      @gamelist = new GameList
      @game = new Game
      setInterval =>
        @game.updateTick()
      , 100


    events: 
      'ws/pixrpg/join': @middleware([Reply]) (message) ->
        @game.playerJoin message

      'ws/disconnect': (message) ->
        @log "Removing #{@s message.connectionid}"
        @game.playerLeave message

      'ws/pixrpg/update': (message) ->
        @game.update message.data
        # @log JSON.stringify message


  return PixrpgController
