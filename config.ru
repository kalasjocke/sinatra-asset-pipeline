require './app'

use Rack::Deflater

configure :development do
  require 'rack-livereload'
  use Rack::LiveReload
end

run App
