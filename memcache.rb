
def reliable_update(dc, key)
  while true
    # tiles.merge!(updates)
    val = yield JSON.parse(dc.get(key))
    json = val.to_json
    dc.set(key, json)
    break if dc.get(key) == json
    sleep(rand(100) * 0.001)
    $stderr.puts "looping"
  end
end

