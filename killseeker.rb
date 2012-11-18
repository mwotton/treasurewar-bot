require './2d_search'
class KillSeeker < Seeker

  def matchval(val, state)
    val['type'] && val['type'] == 'player' && val['x'] && val['y']
  end

end
