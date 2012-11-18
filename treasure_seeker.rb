
class TreasureSeeker < Seeker

  def abort?(state, tiles)
    you = state['you']
    you['item_in_hand'] && you['item_in_hand']['is_treasure']
  end

  def matchval(val, state)
    val['type'] && val['type'] == 'treasure'
  end

end
