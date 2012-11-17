class Killerstrat < Bot
  include BotUtils
  def choose(state, tiles)
    target = nearby(state['you']['position']).select{|point, p| p['type'] == 'player'}.first
    
    if target.nil?
      nil
    else
      return(['attack', { 'dir' => target[0] }])
    end
  end

  def path_find(target)
    'n'
  end
end
