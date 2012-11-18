require './memcache'

class Bot
  def initialize(options)
    @dc = options[:dc]
  end

  def nearest(youpos, targets)
    $stderr.puts({youpos: youpos, targets: targets}.inspect)
    targets.sort_by{|x| dist([youpos['x'], youpos['y']],x)}.first
  end

  def dist(p1, p2)
    $stderr.puts({:p1 => p1, :p2 => p2}).inspect
    [(p1[0] - p2[0]).abs,
     (p1[1] - p2[1]).abs].max
  end
  
end
