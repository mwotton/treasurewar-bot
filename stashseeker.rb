require './2d_search'
class StashSeeker < Seeker
  
  def abort?(state, tiles)
    you = state['you']
    you['item_in_hand'] && you['item_in_hand']['is_treasure']
  end
  
  def matchval(val, state)

    stash = state['you']['stash']

    # if val['type'] == 'stash' && val['treasures'] != []
    #   $stderr.puts(otherstash: val, mystash: stash)
    # end
    
    val['type'] &&
      val['type'] == 'stash' &&
      !(stash['x']==val['x'] && val['y'] == stash['y']) &&
      val['treasures']!=[]
  end

  
end
