require 'spec_helper'

describe Sinatra::AssetPipeline do
  include_context "assets"

  describe App do
    describe "assets_precompile" do
      it { App.assets_precompile.should eq %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff) }
    end

    describe "assets_prefix" do
      it { App.assets_prefix.should eq %w(spec/assets) }
    end

    describe "assets_host" do
      it { App.assets_host.should eq nil }
    end

    describe "assets_protocol" do
      it { App.assets_protocol.should eq :http }
    end

    describe "assets_css_compressor" do
      it { App.sprockets.css_compressor.should eq nil }
    end

    describe "assets_js_compressor" do
      it { App.sprockets.js_compressor.should eq nil }
    end
  end

  describe CustomApp do
    describe "assets_precompile" do
      it { CustomApp.assets_precompile.should eq %w(foo.css foo.js) }
    end

    describe "assets_prefix" do
      it { CustomApp.assets_prefix.should eq %w(spec/assets, foo/bar) }
    end

    describe "assets_host" do
      it { CustomApp.assets_host.should eq 'foo.cloudfront.net' }
    end

    describe "assets_protocol" do
      it { CustomApp.assets_protocol.should eq :https }
    end

    describe "assets_css_compressor" do
      it { CustomApp.sprockets.css_compressor.should eq Sprockets::SassCompressor }
    end

    describe "assets_js_compressor" do
      it { CustomApp.sprockets.js_compressor.should eq Sprockets::UglifierCompressor }
    end
  end

  describe "development environment" do
    include Rack::Test::Methods

    def app
      App
    end

    it "serves an asset" do
      get '/assets/test-_foo.css'
      last_response.should be_ok
      last_response.body.should eq css_content
    end

    it "serves an asset with a digest filename" do
      get '/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg'
      last_response.should be_ok
    end

    it "serves only the asset body with query param body=1" do
      get '/assets/test_body_param.js?body=1'
      last_response.should be_ok
      last_response.body.should eq %Q[var str = "body";\n]
    end
  end
end
