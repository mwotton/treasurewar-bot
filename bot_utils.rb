require './point'
module BotUtils
  def nearby(pos)
    x=pos['x']
    y=pos['y']
    { n: { x: x, y: y-1},
      s: { x: x, y: y+1},
      e: { x: x+1, y: y},
      w: { x: x-1, y: y} }
  end
  
  def surrounding(pos)
    x=pos['x']
    y=pos['y']
    res=[]
    all_points(x-1, x+1, y-1, y+1) do |otherx, othery|
      res << [otherx,othery] unless otherx == x && othery == y
    end
    return res
  end
end
