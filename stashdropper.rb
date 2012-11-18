require './2d_search'
class StashDropper < Bot
  
  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    return nil if !state['you']['item_in_hand']
    return ['drop', {} ] if state['you']['position'] == state['you']['stash']
    
    pos = state['you']['stash']
    $stderr.puts("Trying to get to (#{pos['x']}, #{pos['y']}), currently at (#{state['you']['position']['x']}, #{state['you']['position']['x']})")
    move = @gridsearch.move(tiles, state['you']['position'], pos)
    $stderr.puts "Stash found #{move.inspect}"
    
    return nil unless move
    return ['move', { dir: move } ]
  end
end
