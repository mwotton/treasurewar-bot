require_relative "./point"

class Stash < Point
  attr_accessor :treasure
  def initialize(hash)
    @treasure = hash["treasure"]
    super(hash)
  end
end