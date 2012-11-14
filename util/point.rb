require "ir_b"
class Point
  attr_accessor :x, :y

  def initialize(hash)
    @x = hash["x"] || hash[:x]
    @y = hash["y"] || hash[:y]
  end

  def direction_from(point)
    dx = point.x - @x
    dy = point.y - @y
    case [dx <=> 0, dy <=> 0]
    when [0, -1] then :n
    when [1, -1] then :ne
    when [1, 0] then :e
    when [1, 1] then :se
    when [0, 1] then :s
    when [-1, 1] then :sw
    when [-1, 0] then :w
    when [-1, -1] then :nw
    when [0, 0] then raise("The point at the same position")
    end
  end
end