require './app'
# use Rack::Deflater

NYWalkerServer::RakeMethods.compile_js

map NYWalkerServer.assets_prefix do
  run NYWalkerServer.sprockets
end

map "/" do
  run NYWalkerServer
end

