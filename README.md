# sinatra-asset-pipeline

An asset pipeline implementation for Sinatra based on Sprockets with support for SASS, CoffeeScript and ERB. Built upon [sprockets-sass](https://github.com/petebrowne/sprockets-sass) and [sprockets-helpers](https://github.com/petebrowne/sprockets-helpers) from [petebrowne](https://github.com/petebrowne).

# Installation

Install sinatra-asset-pipeline from RubyGems:

    $ gem install sinatra-asset-pipeline

Or include it in your project's Gemfile with Bundler:

    gem 'sinatra-asset-pipeline'

Make sure to add the sinatra-asset-pipeline Rake task in your applications Rakefile:

    require 'sinatra/asset_pipeline/task.rb'
    require './app'

    Sinatra::AssetPipeline::Task.define! App

Now, when everything is in place you can precompile assets with:

    rake assets:precompile

And remove old compiled assets with:

    rake assets:clean

# Example

In it's most simple form you just register the Sinatra::AssetPipe Sinatra extension within your Sinatra app.

    Bundler.require

    require 'sinatra/asset_pipeline'

    class App < Sinatra::Base
      register Sinatra::AssetPipeline

      get '/' do
        haml :index
      end
    end

However, if your application doesn't follow the defaults you can customize it as follows:

    Bundler.require

    require 'sinatra/asset_pipeline'

    class App < Sinatra::Base
      # Include these files when precompiling assets
      set :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff)

      # Logical path to your assets
      set :assets_prefix, 'assets'

      # Use another host for serving assets
      set :asset_host, 'http://<id>.cloudfront.net'

      # Serve assets using this protocol
      set :assets_protocol, :http

      # Compress CSS using SASS
      set :assets_sass_style, :compress

      register Sinatra::AssetPipeline

      get '/' do
        haml :index
      end
    end

Now when everything is in place you can use all helpers provided by [sprockets-helpers](https://github.com/petebrowne/sprockets-helpers), here is a small example:

      body {
        background-image: image-url('cat.png');
      }

# Compass integration

Given that we're using [sprockets-sass](https://github.com/petebrowne/sprockets-sass) we have out of the box support for compass. Just include the compass gem in your Gemfile and include the compass mixins in your app.css.scss file.

