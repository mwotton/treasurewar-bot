require_relative "./point"
require_relative "./stash"
require_relative "./tile"
require "ir_b"

class World
  attr_accessor :position, :stash
  attr_accessor :nearby_players, :nearby_stashes, :nearby_treasure

  DIRECTIONS = [:n, :nw, :ne, :e, :se, :s, :sw, :w]

  attr_accessor *DIRECTIONS

  def initialize(state)
    @position = Point.new(state["you"]["position"])
    @stash = Stash.new(state["you"]["stash_location"])

    @nearby_players = []
    for player in state["nearby_players"]
      @nearby_players.push Player.new(player)
    end

    for dir, tile in state["tiles"]
      self.send("#{dir}=", Tile.new(tile, dir))
    end
  end

  def surrounding_tiles
    DIRECTIONS.map{|d| self.send(d) }
  end
end