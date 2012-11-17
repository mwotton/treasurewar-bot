class Killerstrat
  def choose(state, tiles)
    target = tiles.select{|point, val| val == 'P' && !}
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
