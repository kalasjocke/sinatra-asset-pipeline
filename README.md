# sinatra-asset-pipeline

An asset pipeline implementation for Sinatra based on [Sprockets](https://github.com/sstephenson/sprockets) with support for CoffeeScript, SASS, SCSS, LESS, ERB as well as CSS (SASS, YUI) and JavaScript (uglifier, YUI or Closure) minification.

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

    $ rake assets:precompile

And remove old compiled assets with:

    $ rake assets:clean

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

      # CSS minification
      set :assets_css_compressor, :sass

      # JavaScript minification
      set :assets_js_minification, :uglifier

      register Sinatra::AssetPipeline

      get '/' do
        haml :index
      end
    end

Now when everything is in place you can use all helpers provided by [sprockets-helpers](https://github.com/petebrowne/sprockets-helpers), here is a small example:

      body {
        background-image: image-url('cat.png');
      }

# CSS and JavaScript minification

If you would like to use CSS and/or JavaScript minification make sure to require the gems needed in your `Gemfile`.

<table>
  <tr>
    <th>Minifier</th>
    <th>Gem</th>
  </tr>
  <tr>
    <td>:sass</td>
    <td>sass</td>
  </tr>
  <tr>
    <td>:closure</td>
    <td>closure-compiler</td>
  </tr>
  <tr>
    <td>:uglifier</td>
    <td>uglifier</td>
  </tr>
  <tr>
    <td>:yui</td>
    <td>yui-compressor</td>
  </tr>
</table>

# Compass integration

Given that we're using [sprockets-sass](https://github.com/petebrowne/sprockets-sass) we have out of the box support for compass. Just include the compass gem in your Gemfile and include the compass mixins in your app.css.scss file.

