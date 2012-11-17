class PriorityQueue 
  def initialize
    @list = []
  end
  def add(priority, item)
    $stderr.puts priority.inspect
    $stderr.puts item.inspect
    @list << [priority, @list.length, item]
    @list.sort!
    self
  end
  def <<(pritem)
    add(*pritem)
  end
  def next
    @list.shift[2]
  end
  def empty?
    @list.empty?
  end
end
