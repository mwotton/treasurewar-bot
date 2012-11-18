require './2d_search'
class StashReturner < Seeker
  def abort?(state, tiles)
    !(state['you']['item_in_hand'] &&state['you']['item_in_hand']['is_treasure'])
  end
  
  def matchval(val, state)
    stash = state['you']['stash']
    val['type'] &&
      val['type'] == 'stash' &&
      (stash['x']==val['x'] && val['y'] == stash['y'])
  end
  
end
