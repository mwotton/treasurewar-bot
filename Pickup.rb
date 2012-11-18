class PickupStash < Bot
  include BotUtils
  def choose(state, tiles)
    you=state['you']
    stash = you['stash']
    pos=you['position']

#    $stderr.puts({:status => item}.inspect)
 #   $stderr.puts({:you => state['you']}.inspect)
    tile = tiles[[pos['x'], pos['y']]]
    if tile && (tile['type'] == 'stash' &&
                !(stash['x'] == pos['x'] && stash['y'] == pos['y']) &&
                tile['treasures']!=[])
      $stderr.puts({:pickups?  => tile }.inspect)
      return ['pick up', { }]
    end
    nil
  end

end

