require_relative "./point"

class Stash < Point
  attr_accessor :treasure
  def initialize(hash)
    @treasures = hash["treasures"]
    super(hash)
  end
end
