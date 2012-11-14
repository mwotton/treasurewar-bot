require_relative "../util/point"
require "rspec"

describe Point do
  let(:point) { Point.new(x: 5, y: 10)}

  describe "#direction_from" do
    it "should be n when point y <" do
      point.direction_from(Point.new(x: 5, y: 9)).should == :n
    end

    it "should be sw when point x < and point y >" do
      point.direction_from(Point.new(x: 4, y: 11)).should == :sw
    end
  end
end