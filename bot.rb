require 'SocketIO'
require "curses"

tiles = {}
auto_explore = true
Curses::init_screen
begin
  Curses::cbreak
  Curses::noecho
  Curses::timeout=(0)
  client = SocketIO.connect("http://localhost:8000") do
    before_start do
      on_message {|message| puts "incoming message: #{message}"}

      # You have about 2 secs between each tick
      on_event('tick') { |game_state|
        state = game_state.first
        tiles[[state['you']['stash']['x'], state['you']['stash']['y']]] = "S"
        
        sight_tiles = {}
        state['tiles'].each { |tile|
          sight_tiles[[tile['x'], tile['y']]] = tile
        }
        (-2..2).each { |y| 
          (-2..2).each { |x|
            if (sight_tiles[[state['you']['position']['x'] + x, state['you']['position']['y'] + y]]== nil)
              tiles[[state['you']['position']['x'] + x, state['you']['position']['y'] + y]] = " "
            else
              tiles[[state['you']['position']['x'] + x, state['you']['position']['y'] + y]] = "#"
            end
          }
        }
        
        (-(Curses.lines / 2)..Curses.lines / 2).each { |yoffset|
          (-(Curses.cols / 2)..Curses.cols / 2).each { |xoffset|
            Curses.setpos((Curses.lines / 2) + yoffset, (Curses.cols / 2) + xoffset)
            Curses.addstr(tiles[[state['you']['position']['x'] + xoffset, state['you']['position']['y'] + yoffset]] == nil ? "." : tiles[[state['you']['position']['x'] + xoffset, state['you']['position']['y'] + yoffset]])
          }
        }
        
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
        if auto_explore
          emit('move', {dir: ['n', 'e', 's', 'w'].sample})
          command = Curses.getch
          if command == 'p'
            auto_explore = false
          end
        else
          direction = Curses.getch
          if ['n', 'e', 's', 'w'].include? direction
            emit('move', {dir: direction})
          elsif direction == 'p'
            auto_explore = true
          end
        end
      }
    end

    after_start do
      emit("set name", "XenphClient v0.1")
    end
  end
ensure
  Curses::close_screen
end
