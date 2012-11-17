class Multistrat
  def initialize(strats)
    @strats = strats
  end

  def choose(state, tiles)
    @strats.each do |s|
      res = s.choose(state,tiles)
      return res if res
    end
    return nil
  end
end
