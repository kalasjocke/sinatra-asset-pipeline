require 'bundler'
Bundler.require

module Sinatra
  module AssetPipeline
    def self.registered(app)
      app.set :sprockets, Sprockets::Environment.new
      app.set :assets_prefix, '/assets'
      app.set :assets_path, -> { File.join(public_folder, assets_prefix) }
      app.set :static, true
      app.set :static_cache_control, [:public, :max_age => 525600]

      app.configure do
        %w{images javascripts stylesheets}.each do |thing|
          app.sprockets.append_path "assets/#{thing}"
        end

        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.digest = true
        end
      end

      app.configure :staging, :production do
        Sprockets::Helpers.configure do |config|
          config.manifest = Sprockets::Manifest.new(app.sprockets, App.assets_path)
        end
      end

      app.configure :production do
        Sprockets::Helpers.configure do |config|
          config.protocol = 'http'
          config.asset_host = 'id.cloudfront.net'
        end
      end

      app.helpers Sprockets::Helpers

      app.configure :development do
        app.get '/assets/*' do |key|
          key.gsub!(/(-\w+)/, "")
          asset = app.sprockets[key]
          content_type asset.content_type
          asset.to_s
        end
      end
    end
  end
end

class App < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    haml :index
  end
end
