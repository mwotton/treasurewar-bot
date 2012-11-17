require './a_star'
require './bot_utils'

class GridSearch
  include BotUtils
  def initialize
    @tiles = {}
    @astar = AStar.new(proc { |pos|
                         x=pos['x']
                         y=pos['y']
                         res=[]
                         all_points(x-1, x+1, y-1, y+1) do |otherx, othery|
                           candidate = @tiles[[otherx,othery]]
                           # $stderr.puts([otherx,othery].inspect)
                           unless (otherx == x and othery == y) or
                               (candidate and candidate['type'] and candidate['type'] == 'wall')

                             # $stderr.puts(candidate.inspect)
                             if candidate && candidate['type'] != 'floor'
                               $stderr.puts candidate['type']
                             end
                             res << { 'x' => otherx,"y" =>  othery }
                           end
                         end
                         res
                       },

                       proc { |x| 1 },
                       proc { |p1,p2|
                         res = [(p1['x'] - p2['x']).abs,
                                (p1['y'] - p2['y']).abs].max
                         res
                       })
  end

  def move(tiles, current, target)
    @tiles = tiles

    path = @astar.find_path(current, target, 100)
    path.shift # don't care about first step
    if path.empty?
      $stderr.puts("empty path")
      nil
    else
      res = BotUtils.to_dir(current, path.first)
      $stderr.puts({
                     :next => path.first,
                     :target => target,
                     :current => current
                   }.inspect)
    

      $stderr.puts("res: #{res.inspect}")
      res
    end
  end
end
