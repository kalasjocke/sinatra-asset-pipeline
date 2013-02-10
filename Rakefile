require 'rake/sprocketstask'
require 'logger'
require './app'

namespace :assets do
  logger = Logger.new($stdout)
  logger.level = Logger::DEBUG

  task :precompile => [:clean, :compile]

  Rake::SprocketsTask.new(:compile) do |t|
    logger.info("Compiling assets")

    t.environment = App.sprockets
    t.output = App.assets_path
    t.logger = logger
    t.assets = App.assets_precompile
  end

  task :clean do
    logger.info("Cleaning assets")

    FileUtils.rm_rf(App.assets_path)
  end
end
