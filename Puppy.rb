class Puppy < Seeker

  def matchval(val, state)
    val['type'] && val['type'] == 'player' &&  val['name'] == "MrPotatoHead"
  end
end
