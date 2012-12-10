require './2d_search'

# so, if this ever fails, we know it's done forever: there will be no
# extra edges created.
class EdgeSeeker < Seeker
  def initialize(*args)
    @valid = true
    super(*args)
  end
  
  def abort?(state, tiles)
    $stderr.puts("asked to abort: #{!@valid}")
    !@valid
  end
  
  def matchval(val, state)
    matched = nil
    # so dumb -  if the val is a player, it's actually in "position"
    val = val['position'] if val['position']
    x=val['x']
    y=val['y']

#    $stderr.puts(state.inspect)
#    $stderr.puts(@tiles.inspect)
#    $stderr.puts({val: val.inspect}.inspect)
    
    all_points(x-1, x+1, y-1,y+1) do |otherx,othery|
      # $stderr.puts("checking #{otherx}, #{othery}")
      matched = matched || !@tiles[[otherx,othery]]
    end

    return matched
  end

  def failed
    $stderr.puts "Failed :("
    @valid = false

  end
end
