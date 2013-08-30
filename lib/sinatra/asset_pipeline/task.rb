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
            manifest = ::Sprockets::Manifest.new(environment.index, app.assets_path)
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
