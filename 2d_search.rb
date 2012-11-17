require './a_star'
require './bot_utils'

class GridSearch
  def initialize
    @astar = AStar.new(proc { |pos|
                         x=pos['x']
                         y=pos['y']
                         res=[]
                         all_points(x-1, x+1, y-1, y+1) do |otherx, othery|
                           res << { 'x' => otherx,"y" =>  othery } unless otherx == x && othery == y
                         end
                         res
                       },

                       proc { |x| 1 },
                       proc { |p1,p2|
                         $stderr.puts p1.inspect
                         $stderr.puts p2.inspect
                         res = [(p1['x'] - p2['x']).abs,
                                (p1['y'] - p2['y']).abs].max
                         $stderr.puts res.inspect
                         res
                       })
  end

  def move(current, target)
    path = @astar.find_path(current, target)
    if path.empty?
      nil
    else
      BotUtils.to_dir(path.first)
    end
  end
end
