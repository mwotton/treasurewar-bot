require './priority_queue'

class AStar
  def initialize(adjacency_func, cost_func, distance_func)
    @adjacency = adjacency_func
    @cost = cost_func
    @distance = distance_func
  end
  
  def find_path(start, goal, cutoff = 10000000)
    been_there = {}
    pqueue = PriorityQueue.new
    pqueue << [1, [start, [], 0]]
    while !pqueue.empty?
      spot, path_so_far, cost_so_far = pqueue.next
      next if been_there[spot]
      newpath = path_so_far + [spot]
      return newpath if (spot == goal)
      been_there[spot] = 1
      @adjacency.call(spot).each do |newspot|
        next if been_there[newspot]
        tcost = @cost.call(spot, newspot)
        next unless tcost
        newcost = cost_so_far + tcost
        if newcost < cutoff
          pqueue << [newcost + @distance.call(goal, newspot),
                     [newspot, newpath, newcost]]
        else
          $stderr.puts "hit cutoff #{cutoff}: #{newcost}"
        end
      end
    end
    return nil
  end

  def find_paths(start, goals, cutoff = 10000000)
    been_there = {}
    pqueue = PriorityQueue.new
    pqueue << [1, [start, [], 0]]
    while !pqueue.empty?
      spot, path_so_far, cost_so_far = pqueue.next
      next if been_there[spot]
      newpath = path_so_far + [spot]
      return newpath if (goals.include? spot)
      been_there[spot] = 1
      @adjacency.call(spot).each do |newspot|
        next if been_there[newspot]
        tcost = @cost.call(spot, newspot)
        next unless tcost
        newcost = cost_so_far + tcost
        if newcost < cutoff
          pqueue << [newcost + goals.map{|g| @distance.call(g, newspot)}.min,
                     [newspot, newpath, newcost]]
        else
          $stderr.puts "hit cutoff #{cutoff}: #{newcost}"
        end
      end
    end
    return nil
  end
  
end
