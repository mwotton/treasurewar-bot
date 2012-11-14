require_relative "./point"

class Tile
  WALL = "W"
  FLOOR = " "
  attr_accessor :dir

  def initialize(key, direction_from_player)
    @key = key
    @dir = direction_from_player
  end

  def wall?; @key == WALL; end
  def floor?; @key == FLOOR; end
end