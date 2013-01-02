require 'sinatra'
require 'haml'

class App < Sinatra::Base
  get '/' do
    haml :index
  end
end
