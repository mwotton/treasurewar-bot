class Pickup < Bot
  include BotUtils
  def choose(state, tiles)
    pos = state['you']['position']
    item = state['you']['item_in_hand'] 
    if item && item['is_treasure']
      stash = state['you']['stash']
      if stash['x'] == pos['x'] && stash['y'] == pos['y']
        ['drop', {}]
      else
        nil
      end
    else
      tile = tiles[[pos['x'], pos['y']]]
      if tile && tile['type'] == 'treasure'
        ['pick up', { }]
      else
        nil
      end
    end
  end

end
