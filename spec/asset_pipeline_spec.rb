require 'spec_helper'

describe Sinatra::AssetPipeline do
  include_context "assets"

  describe App do
    describe "assets_precompile" do
      it { expect(App.assets_precompile).to eq %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2) }
    end

    describe "assets_paths" do
      it { expect(App.assets_paths).to eq %w(assets) }
    end

    describe "assets_host" do
      it { expect(App.assets_host).to be nil }
    end

    describe "assets_protocol" do
      it { expect(App.assets_protocol).to be :http }
    end

    describe "assets_css_compressor" do
      it { expect(App.sprockets.css_compressor).to be nil }
    end

    describe "assets_js_compressor" do
      it { expect(App.sprockets.js_compressor).to be nil }
    end

    describe "assets_digest" do
      it { expect(App.assets_digest).to be true }
    end

    describe "assets_debug" do
      it { expect(App.assets_debug).to be false }
    end

    describe "assets_prefix" do
      it { expect(App.assets_prefix).to eq '/assets' }
    end

    describe "precompiled_environments" do
      it { expect(App.precompiled_environments).to eq %i(staging production) }
    end
  end

  describe CustomApp do
    describe "assets_precompile" do
      it { expect(CustomApp.assets_precompile).to eq %w(foo.css foo.js) }
    end

    describe "assets_paths" do
      it { expect(CustomApp.assets_paths).to eq %w(assets foo/bar) }
    end

    describe "assets_host" do
      it { expect(CustomApp.assets_host).to eq 'foo.cloudfront.net' }
    end

    describe "assets_protocol" do
      it { expect(CustomApp.assets_protocol).to be :https }
    end

    describe "assets_css_compressor" do
      it { expect(CustomApp.sprockets.css_compressor).to eq Sprockets::SassCompressor }
    end

    describe "assets_js_compressor" do
      it { expect(CustomApp.sprockets.js_compressor).to eq Sprockets::UglifierCompressor }
    end

    describe "assets_prefix" do
      it { expect(CustomApp.assets_prefix).to eq '/static' }
    end

    describe "assets_debug" do
      it { expect(CustomApp.assets_debug).to eq true }
    end

    describe "precompiled_environments" do
      it { expect(CustomApp.precompiled_environments).to eq %i(staging uat production) }
    end
  end

  describe "in development environment" do
    include Rack::Test::Methods

    def app
      App
    end

    it "serves an asset" do
      get '/assets/stylesheets/test-_foo.css'

      expect(last_response).to be_ok
      expect(last_response.body).to eq css_content
    end

    it "serves an asset with a digest filename" do
      get '/assets/images/constructocat2-b44344a7a501a79f5080f66bc73d7566f7ed12030819ed0baa7f0f613a65db01.jpg'

      expect(last_response).to be_ok
    end
  end

  describe "path prefix" do
    include Rack::Test::Methods

    def app
      PrefixApp
    end

    it "serves an asset from the specified asset prefix" do
      get '/static/stylesheets/test-_foo.css'

      expect(last_response).to be_ok
      expect(last_response.body).to eq css_content
    end
  end
end
