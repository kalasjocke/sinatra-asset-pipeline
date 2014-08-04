require 'spec_helper'

Sinatra::AssetPipeline::Task.define! App

describe Sinatra::AssetPipeline::Task do
  include_context "assets"

  before(:all) { Dir.chdir "spec" }

  describe "assets:precompile" do
    it "precompiles assets" do
      Rake::Task['assets:precompile'].invoke

      File.exists?(Dir.glob("public/assets/manifest-*.json").first).should be_true

      manifest = JSON.parse File.read(Dir.glob("public/assets/manifest-*.json").first)
      manifest["files"].each_key do |file|
        File.exists?("public/assets/#{file}").should be_true

        File.read("public/assets/#{file}").should eq js_content  if file.end_with? '.js'
        File.read("public/assets/#{file}").should eq css_content if file.end_with? '.css'
      end
    end
  end

  describe "assets:clean" do
    it "cleans precompiled assets" do
      Rake::Task['assets:clean'].invoke

      Dir['public/assets'].should be_empty
    end
  end
end
