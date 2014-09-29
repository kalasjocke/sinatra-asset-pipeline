require 'spec_helper'

describe Sinatra::AssetPipeline do
  include_context "assets"

  describe App do
    describe "assets_precompile" do
      it { expect(App.assets_precompile).to eq %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff) }
    end

    describe "assets_prefix" do
      it { expect(App.assets_prefix).to eq %w(spec/assets) }
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

    describe "assets_path_prefix" do
      it { expect(App.path_prefix).to be nil }
    end

    describe "assets_digest" do
      it { expect(App.assets_digest).to be true }
    end

    describe "assets_expand" do
      it { expect(App.assets_expand).to be false }
    end

    describe "path_prefix" do
      it { expect(App.path_prefix).to be nil }
    end
  end

  describe CustomApp do
    describe "assets_precompile" do
      it { expect(CustomApp.assets_precompile).to eq %w(foo.css foo.js) }
    end

    describe "assets_prefix" do
      it { expect(CustomApp.assets_prefix).to eq %w(spec/assets, foo/bar) }
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

    describe "assets_path_prefix" do
      it { expect(CustomApp.path_prefix).to eq '/static' }
    end

    describe "assets_expand" do
      it { expect(CustomApp.assets_expand).to eq true }
    end
  end

  describe "development environment" do
    include Rack::Test::Methods

    def app
      App
    end

    it "serves an asset" do
      get '/assets/test-_foo.css'

      expect(last_response).to be_ok
      expect(last_response.body).to eq css_content
    end

    it "serves an asset with a digest filename" do
      get '/assets/constructocat2-b5921515627e82a923079eeaefccdbac.jpg'

      expect(last_response).to be_ok
    end

    it "serves only the asset body with query param body=1" do
      get '/assets/test_body_param.js?body=1'

      expect(last_response).to be_ok
      expect(last_response.body).to eq %Q[var str = "body";\n]
    end
  end

  describe "path prefix" do
    include Rack::Test::Methods

    def app
      PrefixApp
    end

    it "serves an asset from the specified path prefix" do
      get '/static/test-_foo.css'

      expect(last_response).to be_ok
      expect(last_response.body).to eq css_content
    end
  end
end
