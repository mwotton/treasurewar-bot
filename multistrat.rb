class Multistrat
  def initialize(strats)
    $stderr.puts "Strats: #{strats.inspect}"
    @strats = strats
  end

  def choose(state, tiles)
    @strats.each do |s|
 
      res = s.choose(state,tiles)
      if res
        $stderr.puts "using #{s.class}"
        return res
      else
        $stderr.puts "skipping #{s.class}"
      end
    end
    return nil
  end
end
