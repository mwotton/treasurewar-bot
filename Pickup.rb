class Pickup < Bot
  include BotUtils
  def choose(state, tiles)
    pos = state['you']['position']
    item = state['you']['item_in_hand']
    stash = state['you']['stash']
    if item && item['is_treasure']

      if stash['x'] == pos['x'] && stash['y'] == pos['y']
        ['drop', {}]
      else
        nil
      end
    else
      tile = tiles[[pos['x'], pos['y']]]
      if tile && (tile['type'] == 'treasure' ||
                  (tile['type'] == 'stash' && (stash['x']!=pos['x'] && stash['y'] != pos['y']) && tile['treasures']!=[]))
        $stderr.puts({:pickupable => tile.inspect})
        ['pick up', { }]
      else
        nil
      end
    end
  end

end

