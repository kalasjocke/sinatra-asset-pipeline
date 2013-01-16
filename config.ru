require 'bundler'
Bundler.require

require './assets/stylesheets/bourbon/lib/bourbon'
require './app'

use Rack::Deflater

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/images'
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'

  Sprockets::Helpers.configure do |config|
    config.environment = environment
    config.digest = true
  end

  App.class_eval do
    helpers Sprockets::Helpers
  end

  run environment
end

map '/' do
  run App
end
