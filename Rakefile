require 'rake/sprocketstask'
require './app'

namespace :assets do
  task :precompile => [:clean, :compile]

  Rake::SprocketsTask.new(:compile) do |t|
    t.environment = App.sprockets
    t.output = App.assets_path
    t.assets = App.assets_precompile
  end

  task :clean do
    FileUtils.rm_rf(App.assets_path)
  end
end
