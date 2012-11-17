require './bot_utils'

class WallHugger
  include BotUtils
  def choose(state,tiles)
    @facing ||= 'n'
    if in_space(state,tiles)
      $stderr.puts "floating aimlessly"
      $stderr.flush
      return(['move', {dir: 'n'}])
    else
      $stderr.puts "man on a mission: #{@facing}"
      $stderr.flush
      return(['move', {dir: @facing = best_move(state, tiles)}])
    end
  end

  def in_space(state, tiles)
    s = surrounding(state['you']['position'])
    s.all? {|x| tiles[x] != '#'}
  end
  
  def best_move(state, tiles)
    directions = %w{ n w s e }
    $stderr.puts @facing
    index = directions.index @facing
    $stderr.puts index
    (-1..2).each do |x|
      # $stderr.puts [x,index,@facing].inspect
      
      next_dir = directions[(x + index) % 4]
      $stderr.puts("considering #{next_dir}")
      return next_dir if free(apply_move(next_dir, state['you']['position']), tiles)
      $stderr.puts("binning #{next_dir}")
    end
    return 'n' # we are trapped in a maze of twisty passages, all the same.
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

