class PickupTreasure < Bot
  include BotUtils
  def choose(state, tiles)
    you=state['you']
    pos=you['position']
    stash = you['stash']


#    $stderr.puts({:status => item}.inspect)
 #   $stderr.puts({:you => state['you']}.inspect)
    tile = tiles[[pos['x'], pos['y']]]
    if tile && tile['type'] == 'treasure'
      ['pick up', { }]
    else
      nil
    end
  end

end

