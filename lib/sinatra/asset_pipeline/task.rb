require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

module Sinatra
  module AssetPipeline
    class Task < Rake::TaskLib
      def initialize(app)
        namespace :assets do
          desc "Precompile assets"
          task :precompile do
            environment = app.sprockets
            environment.css_compressor = app.assets_css_compressor unless app.assets_css_compressor == :none
            environment.js_compressor = app.assets_js_compressor unless app.assets_js_compressor == :none

            manifest = Sprockets::Manifest.new(environment, app.assets_path)
            manifest.compile(app.assets_precompile)
          end

          desc "Clean assets"
          task :clean do
            FileUtils.rm_rf(app.assets_path)
          end
        end
      end

      def self.define!(app)
        self.new app
      end
    end
  end
end
