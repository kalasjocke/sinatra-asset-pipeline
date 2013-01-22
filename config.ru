require './app'

use Rack::Deflater

configure :development do
  require 'rack-livereload'
  use Rack::LiveReload

  map App.assets_prefix do
    run App.sprockets
  end
end

run App
