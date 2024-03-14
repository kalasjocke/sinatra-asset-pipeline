require 'spec_helper'

Sinatra::AssetPipeline::Task.define! App

describe Sinatra::AssetPipeline::Task do
  include_context "assets"

  before(:all) { Dir.chdir "spec" }

  let(:json_manifest) do
    manifest_path = 'public/assets/.sprockets-manifest-*.json'
    globbed = Dir.glob(manifest_path)
    JSON.parse File.read(globbed.first)
  end

  describe "assets:precompile" do
    before { Rake::Task['assets:precompile'].invoke }

    it "generates a manifest" do
      expect(json_manifest).not_to be_empty
    end

    it "precompiles assets" do
      json_manifest["files"].each_key do |file|
        expect(File.exist?("public/assets/#{file}")).to be true
        expect(File.read("public/assets/#{file}")).to eq js_content  if file.end_with? '.js'
        expect(File.read("public/assets/#{file}")).to eq css_content if file.end_with? '.css'
      end
    end
  end

  describe "assets:clean" do
    before { Rake::Task['assets:precompile'].invoke }

    context 'with default keep' do
      it "removes only outdated compiled assets" do
        Rake::Task['assets:clean'].invoke

        expect(Dir['public/assets']).not_to be_empty
      end
    end
  end

  describe "assets:clopper" do
    before { Rake::Task['assets:precompile'].invoke }

    it 'removes all compiled assets' do
      expect(Dir['public/assets']).not_to be_empty
      Rake::Task['assets:clobber'].invoke
      expect(Dir['public/assets']).to be_empty
    end
  end
end
