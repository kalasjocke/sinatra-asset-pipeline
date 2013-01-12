require 'sinatra'

class App < Sinatra::Base
  helpers do
    include Sprockets::Helpers
  end

  get '/' do
    haml :index
  end
end
