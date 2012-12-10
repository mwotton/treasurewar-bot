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

  def getpath(state, tiles)
    targets = tiles.select {|x,val|
      matchval(val, state)
    }.collect {|x| x[0]}
    $stderr.puts({targets: targets}.inspect)

    if targets.empty?
      nil
    else
      t=targets.first
      @gridsearch.move(tiles, state['you']['position'], {'x' => t[0], 'y'=>t[1] })
    end

  end
  
  def choose(state, tiles)
    you = state['you']
    return nil if abort?(state,tiles)
    # possible that the @cachedpath is old - check it's reasonable.
    if @cachedpath && !@cachedpath.empty?
      if BotUtils.to_dir(you['position'], @cachedpath.first) == nil
        $stderr.puts "#{self.class} can't follow #{@cachedpath} from #{you['position']} - resetting"
        @cachedpath = nil
      end
    end
    @cachedpath ||= getpath(state,tiles)
    
    $stderr.puts({ cachedpath: @cachedpath}.inspect)
    if @cachedpath && !@cachedpath.empty?
      best = BotUtils.to_dir(you['position'], @cachedpath.shift)
      @cachedpath = nil if @cachedpath.empty?
      if best
        $stderr.puts("#{self.class} going for #{best}")
        return ['move', { "dir" => best } ]
      end
 
    end
    nil
  end
end
