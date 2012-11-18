require './2d_search'
class TreasureSeeker < Bot

  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    you = state['you']
    return nil if you['item_in_hand'] && you['item_in_hand']['is_treasure']
    current_tile = tiles[[you['position']['x'], you['position']['y']]]
    $stderr.puts current_tile.inspect
    stash = you['stash']
    targets = tiles.select {|x,val|
      val['type'] && (val['type'] == 'treasure' ||
                      (val['type'] == 'stash' &&
                       (stash['x']!=val['x'] && val['y'] != stash['y']) &&
                       val['treasures']!=[]))
    }.collect {|x| x[0]}
    $stderr.puts targets.inspect

    if targets.empty?
      nil
    else
      # TODO go for nearest
      t=nearest(you['position'], targets)
      move = @gridsearch.move(tiles, state['you']['position'], {'x' => t[0], 'y'=>t[1] })
      if move
        $stderr.puts("going for #{tiles['x']},#{tiles['y']}")
        ['move', { dir: move } ]
      else
        nil
      end
    end
  end
end
