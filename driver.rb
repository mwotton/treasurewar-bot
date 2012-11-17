require 'SocketIO'
require "curses"

require './point'
require 'dalli'
require 'json'

require './a_star'
require './2d_search'
require './bot'
require './wallhugger'
require './stashdropper'
require './killerstrat'
require './multistrat'
require './treasurestrat'
require './treasure_seeker'
require './Pickup.rb'
require './Missile'

require './memcache'
dc = Dalli::Client.new('localhost:11211')

class DrunkenWalker < Bot
  def choose(state,tiles)
    return(['move', {dir: ['n', 'e', 's', 'w'].sample}])
  end
end


def render_dashboard(state)
  Curses.setpos(Curses.lines / 2, Curses.cols / 2)
  Curses.addstr("P")
  Curses.setpos(1, 1)
  you = state['you']
  treasure = you['item_in_hand'] && you['item_in_hand']['is_treasure']
  Curses.addstr("Health: #{you['health']} Score: #{you['score']} treasure: #{!!treasure}")
  Curses.refresh
end

def update_world(new_tiles, players, you)
  sight_tiles = {}
  new_tiles.each do |tile|
    sight_tiles[[tile['x'], tile['y']]] = tile
  end
  players.each do |tile|
    pos = tile.delete 'position'
    tile['x'] = pos['x']
    tile['y'] = pos['y']
    sight_tiles[[pos['x'], pos['y']]] = tile
  end
 # you_x = you['position']['x']
 # you_y = you['position']['y']
  
 # all_points(-2,2,-2,2) do |x,y|
 #    ix = [you_x + x, you_y + y]
    
    
 # end
  # return_tiles[[you['stash']['x'], you['stash']['y']]] = "S"
  return sight_tiles
end

begin
  tiles = JSON.parse(dc.get('tiles'))
  $stderr.puts "Found tiles: #{tiles.inspect}"
rescue
  tiles = {}
  dc.set('tiles', "{}")
  $stderr.puts "Tiles not found - initialised on server"
end
auto_explore = true


name = ARGV.shift

strategies = ARGV.collect do |x|
  begin
    Kernel.const_get(x)
  rescue
    nil
  end
end.select {|x| x} 

$stderr.puts "Strats: #{strategies.inspect}"
strategies = [DrunkenWalker] if strategies.empty?
$stderr.puts "Strats: #{strategies.inspect}"
strategy = Multistrat.new(strategies.collect{|x| x.new(dc) })

class Array
  def to_hash
    self.inject({}) { |h, nvp| h[nvp[0]] = nvp[1]; h }
  end
end

def render(tile)
  return '.' if tile.nil?
  case tile['type']
  when 'floor'
    ' '
  when 'wall'
    '#'
  when 'player'
    'P' if tile['name'] == "MrPotatoHead"
    'E' if tile['name'] != "MrPotatoHead"
  when nil
    '#'
  else
    tile['type'][0].upcase
  end
end
oneshot ||= false

Curses::init_screen
begin
  Curses::cbreak
  Curses::noecho
  Curses::timeout=(0)
  
  client = SocketIO.connect("http://treasure-war:8000") do
    before_start do
      on_message {|message| puts "incoming message: #{message}"}

      # You have about 2 secs between each tick
      on_event('tick') do |game_state|
        $stderr.puts("tick")
        state = game_state.first
        you = state['you']

        # $stderr.puts you
        updates = update_world(state['tiles'], state['nearby_players'], you)
        reliable_update(dc,'tiles') do |thing|
          tiles = thing.collect{|x,y| [eval(x),y]}.to_hash
          tiles.merge!(updates)
        end
        
        you_x = you['position']['x']
        you_y = you['position']['y']        
        cols = Curses.cols
        lines = Curses.lines
        all_points((-cols)/2, cols/2,
                   (-lines)/2, lines/2) do |xoffset,yoffset|
          Curses.setpos((lines / 2) + yoffset, (cols / 2) + xoffset)
          # $stderr.puts tiles.inspect
          # $stderr.puts [you_x,xoffset, you_y,yoffset].inspect
          tile = tiles[[you_x + xoffset, you_y + yoffset]]
          # $stderr.puts tile.inspect
          showable = render(tile)
          # $stderr.puts showable.inspect
          Curses.addstr(showable ||= '.')
        end

        render_dashboard state

        if auto_explore || oneshot
          choices = strategy.choose(state,tiles)
          if !choices
            sleep(1000)
            raise "ran out of options"
          end
          
          $stderr.puts choices.inspect
          emit(*choices)

          command = Curses.getch
          auto_explore = false           if command == 'p'
          dc.set('tiles', "{}")          if command == 'c'
          oneshot = false
        else
          direction = Curses.getch
          if ['n', 'e', 's', 'w'].include? direction
            emit('move', {dir: direction})
          elsif direction == 'p'
            auto_explore = true
          elsif direction == 'o'
            oneshot = true
          end
            
        end
      end
    end

    after_start do
      emit("set name", name)
    end
  end
ensure
  Curses::close_screen
end
