require './nywalker-server'
# use Rack::Deflater

map "/" do
  run NYWalkerServer
end

