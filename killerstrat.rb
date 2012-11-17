class Killerstrat < Bot
  include BotUtils
  def choose(state, tiles)
    target = nearby(state['you']['position']).select{|point, p| p['type'] == 'player'}.first
    
    if target.nil?
      nil
    else
      return(['attack', { 'dir' => path_find(target) }])
    end
  end

  def path_find(target)
    to_dir(state['you']['position'], target)
  end
end
