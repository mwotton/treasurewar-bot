require './a_star'
require './bot_utils'

class GridSearch
  include BotUtils
  def initialize
    @tiles = {}
    @paths = {}
    @astar = AStar.new(proc { |pos|
                         x=pos['x']
                         y=pos['y']
                         res=[]
                         all_points(x-1, x+1, y-1, y+1) do |otherx, othery|
                           candidate = @tiles[[otherx,othery]]
                           # $stderr.puts([otherx,othery].inspect)
                           unless (otherx == x and othery == y) or
                               !(candidate and candidate['type']) or
                               candidate['type'] == 'wall'
                             res << { 'x' => otherx,"y" =>  othery }
                           end
                         end

                         # $stderr.puts ({adjacency: res}.inspect) 
                         res
                       },

                       proc { |x| 1},
                       proc { |p1,p2|
                         # $stderr.puts({p1: p1, p2: p2}.inspect)
                         res = [(p1['x'] - p2['x']).abs,
                                (p1['y'] - p2['y']).abs].max
#                         $stderr.puts({p1: p1, p2: p2, res: res}.inspect)
                         # $stderr.puts({distance: res}.inspect)
                         res
                       })
  end


  
  def move(tiles, current, target)
    @tiles = tiles
    if @paths[[current,target]]
      path = @paths[[current,target]]
    else
      path = @paths[[current,target]] = @astar.find_path(current, target, 1000)
    end

    # path.shift rescue nil # don't care about first step
    while path && path.first == current
      path.shift
    end
    
    if !path || path.empty?
      # $stderr.puts("empty path")
      nil
    else

      # $stderr.puts({
      #                :next => path.first,
      #                :target => target,
      #                :current => current
      #              }.inspect)
    

      $stderr.puts({ current: current, step: path}.inspect)
      return path
      # [path.length, res, path]
    end
  end
end
