require 'SocketIO'
require "curses"

require './point'
require 'dalli'
require 'json'

require './a_star'

require './2d_search'
require './bot'
require './Seeker'
require './Puppy'
require './stashseeker'
require './wallhugger'
require './stashreturner'
require './killerstrat'
require './killseeker'
require './multistrat'
require './treasurestrat'
require './Dropper'

require './treasure_seeker'
require './Pickup'
require './PickupTreasure'

require './memcache'
dc = Dalli::Client.new('localhost:11211')

class DrunkenWalker < Bot
  def choose(state,tiles)
    return(['move', {dir: ['n', 'e', 's', 'w'].sample}])
  end
end


def render_dashboard(state, strategy)
  Curses.setpos(Curses.lines / 2, Curses.cols / 2)
  Curses.addstr("P")
  Curses.setpos(1, 1)
  you = state['you']
  treasure = you['item_in_hand'] && you['item_in_hand']['is_treasure']
  Curses.addstr("Health: #{you['health']} Score: #{you['score']} treasure: #{!!treasure}")
  Curses.setpos(2, 1)
  Curses.addstr("Strategy: #{strategy.describe}")
  index = 3
  total = strategy.uses.values.inject(0) {|a,b| a+b}
  sorted = strategy.uses.to_a.sort_by{|x| (-x[1])}
  sorted.each do |name, count|
    Curses.setpos(index, 1)
    index+=1
    Curses.addstr("#{name}: #{100*count/total}%, #{count}")
  end
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
if name =~ /bot/
  rendering=false
else
  rendering = true
end

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
gridsearch=  GridSearch.new
strategy = Multistrat.new(strategies.collect{|x|
                            x.new(gridsearch: gridsearch,
                                  dc: dc) })

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

while true
  begin
    oneshot ||= false
    show_dash = true

    Curses::init_screen
    Curses::cbreak
    Curses::noecho
    Curses::timeout=(0)

    host = "http://treasure-war:8000"
    #     client = SocketIO.connect("http://mp.local:8000") do
    client = SocketIO.connect(host) do

      #    client = SocketIO.connect("http://localhost:8000") do
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
          if rendering
            cols = Curses.cols
            lines = Curses.lines
            all_points((-cols)/2, cols/2,
                       (-lines)/2, lines/2) do |xoffset,yoffset|
              Curses.setpos((lines / 2) + yoffset, (cols / 2) + xoffset)
              tile = tiles[[you_x + xoffset, you_y + yoffset]]
              showable = render(tile)
              Curses.addstr(showable ||= '.')
            end

            render_dashboard state, strategy if show_dash
          end
          if auto_explore || oneshot
            choices = strategy.choose(state,tiles)
            if !choices
              raise "ran out of options"
            end
            
            $stderr.puts choices.inspect
            emit(*choices)
            if rendering
              command = Curses.getch
              auto_explore = false           if command == 'p'
              show_dash = !show_dash         if command == 'd'
              dc.set('tiles', "{}")          if command == 'c'
              
              oneshot = false
            end
          else
            if rendering
              command = Curses.getch
              show_dash = !show_dash         if command == 'd'
              if ['n', 'e', 's', 'w'].include? command
                emit('move', {dir: command})
              elsif command == 'p'
                auto_explore = true
              elsif command == 'o'
                oneshot = true
              end
            end
          end
        end
      end

      after_start do
        emit("set name", name)
      end
    end
  rescue Errno::ECONNRESET => e
    $stderr.puts e.inspect
    $stderr.puts e.backtrace
    $stderr.puts e.class
    
    dc.set('tiles', "{}")
  end
end

Curses::close_screen

