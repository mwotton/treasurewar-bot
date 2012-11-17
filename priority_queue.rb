class PriorityQueue 
  def initialize
    @list = []
  end
  def add(priority, item)
#    $stderr.puts "Prio: #{priority.inspect}"
#    $stderr.puts "item: #{item.inspect}"
    @list << [priority, @list.length, item]
#    $stderr.puts "list: #{@list.inspect}"
    @list.sort_by! {|x| [x[0], x[1]] }
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
