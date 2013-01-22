require 'bundler'
Bundler.require

class App < Sinatra::Base
  set :sprockets, Sprockets::Environment.new
  set :assets_prefix, '/assets'
  set :assets_path, -> { File.join(public_folder, assets_prefix) }
  set :static, true
  set :static_cache_control, [:public, :max_age => 525600]

  configure do
    %w{images javascripts stylesheets}.each do |thing|
      sprockets.append_path "assets/#{thing}"
    end

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.digest = true
    end
  end

  configure :staging, :production do
    Sprockets::Helpers.configure do |config|
      config.manifest = Sprockets::Manifest.new(sprockets, App.assets_path)
    end
  end

  configure :production do
    Sprockets::Helpers.configure do |config|
      config.protocol = 'http'
      config.asset_host = 'id.cloudfront.net'
    end
  end

  helpers Sprockets::Helpers

  get '/' do
    haml :index
  end
end
