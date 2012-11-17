require_relative "../bot_utils.rb"
require "rspec"

describe BotUtils do

  
  describe "#surrounding" do
    it "should return the list" do
      BotUtils.surrounding('x' => 3, 'y' => 44).sort.should ==
        [[2,43],[3,43],[4,43],
         [2,44],       [4,44],
         [2,45],[3,45],[4,45]].sort
    end
  end
end
