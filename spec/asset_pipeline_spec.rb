require 'spec_helper'

require 'sinatra'
require 'sinatra/asset_pipeline'
require 'sinatra/asset_pipeline/task.rb'

class App < Sinatra::Base
  register Sinatra::AssetPipeline
end

Sinatra::AssetPipeline::Task.define! App

describe Sinatra::AssetPipeline do
  let(:js_content) do
    <<eos
(function() {
  (function() {});

}).call(this);
eos
  end

  let(:css_content) do
    <<eos
html, body {
  margin: 0;
  padding: 0; }
eos
  end

  describe "rake task" do
    it "precompiles assets" do
      Rake::Task['assets:precompile'].invoke

      File.read('public/assets/app-e861868bbd5547a396819c648cfec59b.js').should == js_content
      File.read('public/assets/app-bd224f30568e7dea2a28fa2ad3079f45.css').should == css_content
      File.exists?('public/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg').should == true
    end

    it "cleans precompiled assets" do
      Rake::Task['assets:clean'].invoke

      Dir['public/assets'].should == []
    end
  end

  describe 'development environment' do
    include Rack::Test::Methods

    def app
      App
    end

    it "serves an asset" do
      get '/assets/test-_foo.css'
      last_response.should be_ok
      last_response.body.should == css_content
    end

    it "serves an asset with a digest filename" do
      get '/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg'
      last_response.should be_ok
    end

    it "serves only the asset body with query param body=1" do
      get '/assets/test_body_param.js?body=1'
      last_response.body.should == %Q[var str = "body";\n]
    end
  end
end
