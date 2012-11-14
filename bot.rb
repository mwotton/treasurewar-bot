# require 'faye/websocket'
# require 'eventmachine'

# EM.run do
#   ws = Faye::WebSocket::Client.new('ws://localhost:3001')

#   ws.onopen = lambda do |event|
#     p [:open]
#     ws.send('Hello, world!')
#   end

#   ws.onmessage = lambda do |event|
#     p [:message, event.data]
#   end

#   ws.onclose = lambda do |event|
#     p [:close, event.code, event.reason]
#     ws = nil
#   end
# end
require 'SocketIO'
client = SocketIO.connect("http://localhost:3001") do
  before_start do
    on_message {|message| puts "incoming message: #{message}"}
    on_event('news') { |data| puts data.first} # data is an array fo things.
    on_event('message') { |data| puts data } # data is an array fo things.
  end
end