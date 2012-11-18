class Dropper < Bot
  include BotUtils
  def choose(state, tiles)
    you=state['you']
    item = you['item_in_hand']
    if item && item['is_treasure']
      stash = you['stash']
      pos = you['position']
      if stash['x'] == pos['x'] && stash['y'] == pos['y']
        return ['drop', {}]
      end
    end
    nil
  end
end
