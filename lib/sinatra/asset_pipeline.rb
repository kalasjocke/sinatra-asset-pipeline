require 'sprockets'
require 'sprockets-helpers'

module Sinatra
  module AssetPipeline
    def self.registered(app)
      app.set_default :sprockets, Sprockets::Environment.new
      app.set_default :assets_paths, %w(assets)
      app.set_default :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)
      app.set_default :assets_public_path, -> { File.join(public_folder, "assets") }
      app.set_default :assets_protocol, :http
      app.set_default :assets_css_compressor, nil
      app.set_default :assets_js_compressor, nil
      app.set_default :assets_host, nil
      app.set_default :assets_prefix, '/assets'
      app.set_default :assets_digest, true
      app.set_default :assets_debug, false

      app.set :static, :true
      app.set :static_cache_control, [:public, :max_age => 60 * 60 * 24 * 365]

      app.configure do
        app.assets_paths.each do |path|
          app.sprockets.append_path File.join(app.root, path)
        end

        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.digest = app.assets_digest
          config.prefix = app.assets_prefix unless app.assets_prefix.nil?
          config.debug = app.assets_debug
        end
      end

      app.configure :staging, :production do
        Sprockets::Helpers.configure do |config|
          config.manifest = Sprockets::Manifest.new(app.sprockets, app.assets_public_path)
          config.prefix = app.assets_prefix unless app.assets_prefix.nil?
        end
      end

      app.configure :staging, :production do
        app.sprockets.css_compressor = app.assets_css_compressor unless app.assets_css_compressor.nil?
        app.sprockets.js_compressor = app.assets_js_compressor unless app.assets_js_compressor.nil?

        Sprockets::Helpers.configure do |config|
          config.protocol = app.assets_protocol
          config.asset_host = app.assets_host unless app.assets_host.nil?
          config.prefix = app.assets_prefix unless app.assets_prefix.nil?
        end
      end

      app.helpers Sprockets::Helpers

      app.configure :test, :development do
        app.get "#{app.assets_prefix}/*" do |path|
          env_sprockets = request.env.dup
          env_sprockets['PATH_INFO'] = path
          settings.sprockets.call env_sprockets
        end
      end
    end

    def set_default(key, default)
      self.set(key, default) unless self.respond_to? key
    end
  end
end
