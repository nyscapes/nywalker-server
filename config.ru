require './app'
# use Rack::Deflater

App::RakeMethods.compile_js

map App.assets_prefix do
  run App.sprockets
end

map "/" do
  run App
end

