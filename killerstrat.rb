class Killerstrat < Bot
  include BotUtils
  def choose(state, tiles)
    you = state['you']
    near = surrounding(you['position']).map{|x| tiles[x]}.compact
    $stderr.puts({:near => near}.inspect)
    target = near.select do |tile|
      tile['type'] == 'player' &&
        tile['name'] != 'MrPotatoHead'
    end.first
    
    if target==nil || target.empty?
      nil
    else
      $stderr.puts({:state => state, :you => you['position'], :target => target}.inspect)
      return(['attack', { 'dir' => BotUtils.to_dir(you['position'], target) }])
    end
  end
end
