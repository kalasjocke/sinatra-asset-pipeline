require 'spec_helper'

require 'sinatra'
require 'sinatra/asset_pipeline'
require 'sinatra/asset_pipeline/task.rb'

class App < Sinatra::Base
  register Sinatra::AssetPipeline
end

Sinatra::AssetPipeline::Task.define! App

  let(:js_content) {
    <<eos
(function() {
  $(function() {
    return console.log("Boom");
  });

}).call(this);
eos
  }
  let(:css_content) {
    <<eos
html, body {
  margin: 0;
  padding: 0; }
eos
  }

  it "assets:precompile to precompile assets" do
    Rake::Task['assets:precompile'].invoke

    File.read('public/assets/app-a4462e8edd8f78290d836e3f2f524160.js').should == js_content
    File.read('public/assets/app-bd224f30568e7dea2a28fa2ad3079f45.css').should == css_content
    File.exists?('public/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg').should == true
  end

  it "assets:clean to clean assets" do
    Rake::Task['assets:clean'].invoke

    Dir['public/assets'].should == []
  end

  describe 'the asset pipeline with a basic sinatra app' do
    include Rack::Test::Methods

    def app
      App
    end

    it "serve an asset whatever name it have" do
      get '/assets/test-_foo.css'
      last_response.should be_ok
      last_response.body.should == css_content
    end

    it "serve an asset when it is called with is digest" do
      get '/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg'
      last_response.should be_ok
    end
  end
end
