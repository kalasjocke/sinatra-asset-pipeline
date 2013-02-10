require 'bundler'
Bundler.require

module Sinatra
  module AssetPipeline
    def self.registered(app)
      app.set_default :sprockets, Sprockets::Environment.new
      app.set_default :assets_precompile, %w(app.js app.css *.png *.jpg)
      app.set_default :assets_prefix, 'assets'
      app.set_default :assets_path, -> { File.join(public_folder, assets_prefix) }
      app.set_default :assets_digest, true
      app.set_default :assets_protocol, 'http'
      app.set_default :static, true
      app.set_default :static_cache_control, [:public, :max_age => 525600]

      app.configure do
        Dir[File.join app.assets_prefix, "*"].each {|path| app.sprockets.append_path path}

        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.digest = App.assets_digest
        end
      end

      app.configure :staging, :production do
        Sprockets::Helpers.configure do |config|
          config.manifest = Sprockets::Manifest.new(app.sprockets, App.assets_path)
        end
      end

      app.configure :production do
        Sprockets::Helpers.configure do |config|
          config.protocol = App.assets_protocol
          config.asset_host = App.assets_host if App.respond_to? :assets_host
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

    def set_default(key, default)
      self.set(key, default) unless App.respond_to? key
    end
 end
end

class App < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    haml :index
  end
end
