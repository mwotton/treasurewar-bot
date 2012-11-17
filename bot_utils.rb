require './point'
module BotUtils
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
