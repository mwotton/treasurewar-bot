require './2d_search'
class TreasureSeeker < Bot

  def initialize(*args)
    @gridsearch = GridSearch.new
    super(*args)
  end
  
  def choose(state, tiles)
    return nil if state['you']['item_in_hand'] && state['you']['item_in_hand']['is_treasure']
    return ['pick up', {} ] if tiles[[state['you']['position']['x'], state['you']['position']['y']]]['type'] == 'treasure'
    targets = tiles.select {|x,val|
    
      val['type'] && (val['type'] == 'treasure')
    }.collect {|x| x[0]}
    $stderr.puts targets.inspect

    if targets.empty?
      nil
    else
      t=targets.first
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
