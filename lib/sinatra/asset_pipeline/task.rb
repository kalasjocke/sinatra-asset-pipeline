require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

module Sinatra
  module AssetPipeline
    class Task < Rake::TaskLib
      def initialize(app_klass)
        namespace :assets do
          desc "Precompile assets"
          task :precompile do
            environment = app_klass.sprockets
            manifest = ::Sprockets::Manifest.new(environment.index, app_klass.assets_public_path)
            manifest.compile(app_klass.assets_precompile)
          end

          desc "Clean assets"
          task :clean do
            FileUtils.rm_rf(app_klass.assets_public_path)
          end
        end
      end

      def self.define!(app_klass)
        self.new app_klass
      end
    end
  end
end
