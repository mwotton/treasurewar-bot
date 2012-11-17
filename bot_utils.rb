require './point'
module BotUtils
  def nearby(pos)
    x=pos['x']
    y=pos['y']
    { n: { x: x, y: y-1},
      ne: { x: x+1, y: y-1},
      nw: { x: x-1, y: y-1},
      
      s: { x: x, y: y+1},
      se: { x: x+1, y: y+1},
      sw: { x: x-1, y: y+1},

      e: { x: x+1, y: y},
      w: { x: x-1, y: y} }
  end

  def to_dir(from, to)
    xdiff = to['x'] - from['x']
    ydiff = to['y'] - from['y']
    hash = {
      [0,1] => 's',
      [1,1] => 'se',
      [-1, 1] => 'sw',
      
      [0,-1] => 'n',
      [1,-1] => 'ne',
      [-1, -1] => 'nw',

      [1,0] => 'e',
      [0,1] => 'w'
    }
    hash[[xdiff,ydiff]]
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
