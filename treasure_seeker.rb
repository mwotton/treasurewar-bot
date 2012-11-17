require './2d_search'
class Missile < Bot

  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    pos = { 'x' => 5, 'y' => 3 }
    sq = tiles[[5,3]]
    $stderr.puts("trying to get to (5,3), currently at #{state['you']['position']}")
    if sq && sq['type'] && sq['type']=='wall'
      $stderr.puts "asked me to walk into a wall"
      return nil
    end
    move = @gridsearch.move(tiles, state['you']['position'], pos)
    $stderr.puts "missile found #{move.inspect}"
    return nil unless move
    return ['move', { dir: move } ]
  end
end
