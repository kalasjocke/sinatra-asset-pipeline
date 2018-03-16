require 'rake'
require 'rake/sprocketstask'
require 'sprockets'

module Sinatra
  module AssetPipeline
    class Task < Rake::SprocketsTask
      attr_accessor :app

      def initialize(app = nil)
        self.app = app
        super()
      end

      def environment
        app ? app.sprockets : super
      end

      def assets
        app ? app.assets_precompile : super
      end

      def manifest
        app ? Sprockets::Manifest.new(environment.index, app.assets_public_path) : super
      end

      def define
        namespace :assets do
          %w( precompile clean clobber ).each { |task| Rake::Task[task].clear if Rake::Task.task_defined?(task) }

          desc "Compile all assets"
          task :precompile do
            manifest.compile(assets)
          end

          desc "Remove old compiled assets"
          task :clean, [:keep] do |t, args|
            manifest.clean(Integer(args.keep || self.keep))
          end

          desc "Remove compiled assets"
          task :clobber do
            manifest.clobber
          end
        end
      end

      def self.define!(app)
        self.new(app)
      end
    end
  end
end
