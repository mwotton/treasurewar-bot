class Multistrat
  def initialize(strats)
    $stderr.puts "Strats: #{strats.inspect}"
    @strats = strats
    @current = nil
    @uses = {}
  end

  def choose(state, tiles)
    @strats.each do |s|
 
      res = s.choose(state,tiles)
      if res
        $stderr.puts "using #{s.class}"
        @current = s
        @uses[s.class] ||= 0
        @uses[s.class] += 1
        return res
      else
        $stderr.puts "skipping #{s.class}"
      end
    end
    return nil
  end

  def describe
    @current.class
  end

  def uses
    @uses
  end
  
end
