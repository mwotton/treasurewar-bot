class Treasurestrat < Bot
  def choose(state, tiles)
    target = tiles.find{|point, val| val == 'T'}
    if target
      return(['move', { 'dir' => path_find(target[0])}])
    else
      nil
    end
  end

  def path_find(target)
    'n'
  end
end
