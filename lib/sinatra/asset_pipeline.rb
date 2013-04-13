require 'sprockets'
require 'sprockets-sass'
require 'sprockets-helpers'

module Sinatra
  module AssetPipeline
    def self.registered(app)
      app.set_default :sprockets, Sprockets::Environment.new
      app.set_default :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff)
      app.set_default :assets_prefix, 'assets'
      app.set_default :assets_path, -> { File.join(public_folder, assets_prefix) }
      app.set_default :assets_protocol, :http
      app.set_default :assets_css_compressor, :none
      app.set_default :assets_js_compressor, :none
      app.set_default :assets_digest, true
      app.set_default :assets_expand, false
      app.set_default :assets_debug, false

      app.set :static, true
      app.set :static_cache_control, [:public, :max_age => 525600]

      app.configure do
        Dir[File.join app.assets_prefix, "*"].each {|path| app.sprockets.append_path path}

        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.digest = app.assets_digest
          config.expand = app.assets_expand
          if app.assets_debug
            config.digest = false
            config.expand = true
          end
        end
      end

      app.configure :staging, :production do
        Sprockets::Helpers.configure do |config|
          config.manifest = Sprockets::Manifest.new(app.sprockets, app.assets_path)
        end
      end

      app.configure :production do
        app.sprockets.css_compressor = app.assets_css_compressor unless app.assets_css_compressor == :none
        app.sprockets.js_compressor = app.assets_js_compressor unless app.assets_js_compressor == :none

        Sprockets::Helpers.configure do |config|
          config.protocol = app.assets_protocol
          config.asset_host = app.assets_host if app.respond_to? :assets_host
        end
      end

      app.helpers Sprockets::Helpers

      app.configure :development do
        app.get '/assets/*' do |key|
          if Sprockets::Helpers.digest
          	key.gsub! /(-\w+)(?!.*-\w+)/, ""
          end
		  asset = app.sprockets[key]
          content_type asset.content_type
		  if Sprockets::Helpers.expand
		  	return asset.body
		  end
          asset.to_s
        end
      end
    end

    def set_default(key, default)
      self.set(key, default) unless self.respond_to? key
    end
  end
end
