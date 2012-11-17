def all_points(left, right, top, bottom)
  (top..bottom).each do |y|
    (left..right).each do |x|
      yield x,y
    end
  end
end
