require 'spec_helper'

require 'sinatra'
require 'sinatra/asset_pipeline'
require 'sinatra/asset_pipeline/task.rb'

describe Sinatra::AssetPipeline do
  class App < Sinatra::Base
    register Sinatra::AssetPipeline
  end

  Sinatra::AssetPipeline::Task.define! App

  it "assets:precompile to precompile assets" do
    Rake::Task['assets:precompile'].invoke

    File.read('public/assets/app-a4462e8edd8f78290d836e3f2f524160.js').should == <<eos
(function() {
  $(function() {
    return console.log("Boom");
  });

}).call(this);
eos
    File.read('public/assets/app-bd224f30568e7dea2a28fa2ad3079f45.css').should == <<eos
html, body {
  margin: 0;
  padding: 0; }
eos
    File.exists?('public/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg').should == true
  end

  it "assets:clean to clean assets" do
    Rake::Task['assets:clean'].invoke

    Dir['public/assets'].should == []
  end
end
