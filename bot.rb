require 'SocketIO'
require "curses"

def all_points(left, right, top, bottom)
  (top..bottom).each do |x|
    (left..right).each do |y|
      yield x,y
    end
  end
end

class DrunkenWalker
  def choose(state)
    return(['move', {dir: ['n', 'e', 's', 'w'].sample}])
  end
end

class WallHugger
  def choose(state)
    if in_space(state)
      @facing = 'n'
      return(['move', {dir: 'n'}])
    else
      return(['move', {dir: best_move(state['tiles'])}])
    end
  end

  def in_space(state)
    true
  end
  
  def best_move(tiles)
    $stderr.puts tiles.inspect
    return 'e'
  end
end


def render_dashboard(state)
  Curses.setpos(Curses.lines / 2, Curses.cols / 2)
  Curses.addstr("P")
  Curses.setpos(1, 1)
  Curses.addstr("Health: #{state['you']['health']} Treasure: #{state['nearby_treasure'].inspect}")
  Curses.setpos(2, 1)
  Curses.addstr("Stashes: #{state['nearby_stashes'].inspect}")
  Curses.setpos(3, 1)
  Curses.addstr("Current Position: #{state['you']['position']['x']}, #{state['you']['position']['y']}")
  Curses.setpos(4, 1)
  Curses.addstr("Stash Position: #{state['you']['stash']['x']}, #{state['you']['stash']['y']}")
  Curses.refresh
end

def update_world(new_tiles, you)
  return_tiles = {}
  sight_tiles = {}
  new_tiles.each do |tile|
    sight_tiles[[tile['x'], tile['y']]] = tile['type']
  end
  
  you_x = you['position']['x']
  you_y = you['position']['y']
  
  all_points(-2,2,-2,2) do |x,y|
    ix = [you_x + x, you_y + y]
    return_tiles[ix] = case sight_tiles[ix]
                       when 'floor'
                         ' '
                       when 'wall'
                         '#'
                       when 'player'
                       else
                         sight_tiles[ix].nil? ? '.' : sight_tiles[ix][0].upcase
                       end
  end
  return_tiles[[you['stash']['x'], you['stash']['y']]] = "S"
  return return_tiles
end

tiles = {}
auto_explore = true

strategy =  (Kernel.const_get(ARGV[0]) rescue DrunkenWalker).new

Curses::init_screen
begin
  Curses::cbreak
  Curses::noecho
  Curses::timeout=(0)
  
  client = SocketIO.connect("http://localhost:8000") do
    before_start do
      on_message {|message| puts "incoming message: #{message}"}

      # You have about 2 secs between each tick
      on_event('tick') do |game_state|
        
        state = game_state.first
        you = state['you']
        tiles.merge!(update_world(state['tiles'], you))

        you_x = you['position']['x']
        you_y = you['position']['y']        
        
        all_points((-Curses.lines)/2, Curses.lines/2,
                   (-Curses.cols)/2, Curses.cols/2) do |xoffset,yoffset|
          Curses.setpos((Curses.lines / 2) + yoffset, (Curses.cols / 2) + xoffset)
          ix = [you_x + xoffset, you_y + yoffset]
          Curses.addstr(tiles[ix] == nil ? "." : tiles[ix])
        end

        render_dashboard state

        if auto_explore
          emit(*strategy.choose(state))
          command = Curses.getch
          auto_explore = false           if command == 'p'
        else
          direction = Curses.getch
          if ['n', 'e', 's', 'w'].include? direction
            emit('move', {dir: direction})
          elsif direction == 'p'
            auto_explore = true
          end
        end
      end
    end

    after_start do
      emit("set name", "XenphClient v0.1")
    end
  end
ensure
  Curses::close_screen
end
