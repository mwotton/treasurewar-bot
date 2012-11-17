require './2d_search'
class Missile < Bot

  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    move = @gridsearch.move(state['you']['position'], state['you']['stash'])
    return nil unless move
    return ['move', { dir: move } ]
  end
end
