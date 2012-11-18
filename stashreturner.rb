require './2d_search'
class StashReturner < Bot
  
  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    $stderr.puts state['you'].inspect
    return nil if !state['you']['item_in_hand']

    #     return ['drop', {} ] if state['you']['position'] == state['you']['stash']
    you = state['you']
    stash = you['stash']
    $stderr.puts("Trying to get to (#{stash['x']}, #{stash['y']}), currently at (#{you['position']['x']}, #{you['position']['x']})")
    move = @gridsearch.move(tiles, you['position'],
                            {'x' => stash['x'], 'y' => stash['y']})
    $stderr.puts "Stash found #{move.inspect}"
    
    return nil unless move
    return ['move', { dir: move } ]
  end
end
