require 'spec_helper'

Sinatra::AssetPipeline::Task.define! App

describe Sinatra::AssetPipeline::Task do
  include_context "assets"

  before(:all) { Dir.chdir "spec" }

  describe "assets:precompile" do
    it "precompiles assets" do
      Rake::Task['assets:precompile'].invoke

      expect(File.exists?(Dir.glob("public/assets/manifest-*.json").first)).to be true

      manifest = JSON.parse File.read(Dir.glob("public/assets/manifest-*.json").first)

      manifest["files"].each_key do |file|
        expect(File.exists?("public/assets/#{file}")).to be true
        expect(File.read("public/assets/#{file}")).to eq js_content  if file.end_with? '.js'
        expect(File.read("public/assets/#{file}")).to eq css_content if file.end_with? '.css'
      end
    end
  end

  describe "assets:clean" do
    it "cleans precompiled assets" do
      Rake::Task['assets:clean'].invoke

      expect(Dir['public/assets']).to be_empty
    end
  end
end
