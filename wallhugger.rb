require './bot_utils'

class WallHugger
  include BotUtils
  def choose(state,tiles)
    @facing ||= 'n'
    @visited ||= {}
    @visited[state['you']['position']] ||= 0
    @visited[state['you']['position']] += 1
    if in_space(state,tiles)
      return(['move', {dir: 'n'}])
    else
      @facing = best_move(state, tiles)
      if @facing
        return(['move', {dir: @facing}])
      else
        return nil
      end
    end
  end

  def in_space(state, tiles)
    s = surrounding(state['you']['position'])
    s.all? {|x| tiles[x] != '#'}
  end
  
  def best_move(state, tiles)
    directions = %w{ n w s e }
    index = directions.index @facing
    (-1..2).each do |x|
      # $stderr.puts [x,index,@facing].inspect
      next_dir = directions[(x + index) % 4]
      next_pos = apply_move(next_dir, state['you']['position'])
      return next_dir if free(next_pos, tiles) and (!@visited[next_pos] or @visited[next_pos] < 4)
    end
    return nil # i got nothin

  end

  private

  def free(pos, tiles)
    tiles[[pos['x'], pos['y']]] != '#'
  end
  
  def apply_move(dir, pos)
    case dir
    when 'n'
      { "x" => pos['x'], "y" => pos['y'] - 1 }
    when 's'
      { "x" => pos['x'], "y" => pos['y'] + 1 }
    when 'e'
      { "x" => pos['x'] + 1, "y" => pos['y'] }
    when 'w'
      { "x" => pos['x'] - 1, "y" => pos['y'] }
    else
      raise "stop fucking around: #{dir}"
    end
  end
      
      
end

