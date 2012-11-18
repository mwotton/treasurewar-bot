require './memcache'

class Bot
  def initialize(dc)
    @dc = dc
  end

  def nearest(youpos, targets)
    targets.sort_by{|x| dist(youpos,x)}.first
  end
end
