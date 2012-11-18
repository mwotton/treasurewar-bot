class Killerstrat < Bot
  include BotUtils
  def choose(state, tiles)
    you = state['you']
    near = surrounding(you['position']).map{|x| tiles[x]}

    target = near.select{|tile| tile['type'] == 'player'}.first
    
    if target==nil || target.empty?
      nil
    else
      $stderr.puts({:state => state, :you => you['position'], :target => target}.inspect)
      return(['attack', { 'dir' => BotUtils.to_dir(you['position'], target) }])
    end
  end
end
