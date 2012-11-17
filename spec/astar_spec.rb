load './a_star.rb'

describe AStar do
  describe 'trivial' do
    it 'should add numbers' do
      @simple = AStar.new(proc { |x| [x+1, x-1]},
                          proc { |x,y| 1 },
                          proc { |x,y| (x-y).abs })

      @simple.find_path(0, 3).should == [0,1,2,3]
    end
  end
end
