require 'sprockets'
require './assets/stylesheets/bourbon/lib/bourbon'
require './app'

use Rack::Deflater

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/images'
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'

  run environment
end

map '/' do
  run App
end
