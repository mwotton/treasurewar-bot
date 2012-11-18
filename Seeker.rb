require './2d_search'
class Seeker < Bot

  def initialize(options)
    @gridsearch = options[:gridsearch]
    super(options)
  end

  def abort?(state,tiles)
    false
  end

  def matchval(type, state)
    false
  end
  
  def choose(state, tiles)
    you = state['you']
    return nil if abort?(state,tiles)
    current_tile = tiles[[you['position']['x'], you['position']['y']]]
    $stderr.puts current_tile.inspect
    stash = you['stash']
    targets = tiles.select {|x,val|
      matchval(val, state)
    }.collect {|x| x[0]}
    $stderr.puts({targets: targets}.inspect)

    if targets.empty?
      nil
    else
      # TODO go for nearest
      t=nearest(you['position'], targets)
      move = @gridsearch.move(tiles, state['you']['position'], {'x' => t[0], 'y'=>t[1] })
      if move
        $stderr.puts("#{self.class} going for #{t[0]},#{t[1]}")
        ['move', { dir: move } ]
      else
        nil
      end
    end
  end
end
