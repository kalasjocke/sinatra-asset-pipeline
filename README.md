Sinatra Asset Pipeline [![Build Status](https://github.com/kalasjocke/sinatra-asset-pipeline/actions/workflows/test.yml/badge.svg)](https://github.com/kalasjocke/sinatra-asset-pipeline/actions/workflows/test.yml)
======================

An asset pipeline implementation for Sinatra based on [Sprockets](https://github.com/rails/sprockets). sinatra-asset-pipeline supports both compiling assets on the fly for development as well as precompiling assets for production. The design goal for sinatra-asset-pipeline is to provide good defaults for integrating your Sinatra application with Sprockets.

# Installation

Install Sinatra Asset Pipeline from RubyGems:

```bash
gem install sinatra-asset-pipeline
```

Or, include it in your project's `Gemfile`:

```ruby
gem 'sinatra-asset-pipeline', '~> 2.2.0'
```

# Usage

Add the provided Rake tasks to your applications `Rakefile`:

```ruby
require 'sinatra/asset_pipeline/task'
require './app'

Sinatra::AssetPipeline::Task.define! App
```

This makes your application serve assets inside `assets` folder under the public `/assets` path. You can use the helpers provided by [sprocket-helpers](https://github.com/petebrowne/sprockets-helpers) inside your assets to ease locating your assets.

During deployment of your application you can use `precompile` rake task to precompile your assets to serve them as static files from your applications public folder.

```bash
RACK_ENV=production rake assets:precompile
```

To leverage the Sprockets preprocessor pipeline inside your app you can use the `assets_js_compressor` and `assets_css_compressor` settings respectively. See the [Using Processors](https://github.com/rails/sprockets#using-processors) section of the Sprockets readme for details.

## Classic style

If your application runs Sinatra in classic style you can define your Rake tasks as follows:

```ruby
Sinatra::AssetPipeline::Task.define! Sinatra::Application
```

# Customization

In its most simple form, you just register the `Sinatra::AssetPipeline` Sinatra extension within your application:

```ruby
require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    'hi'
  end
end
```

However, if your application doesn't follow the defaults you can customize it as follows:

```ruby
require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  # Include these files when precompiling assets
  set :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

  # The path to your assets
  set :assets_paths, %w(assets)

  # Use another host for serving assets
  set :assets_host, '<id>.cloudfront.net'

  # Which prefix to serve the assets under
  set :assets_prefix, 'custom-prefix'

  # Serve assets using this protocol (http, :https, :relative)
  set :assets_protocol, :http

  # CSS minification
  set :assets_css_compressor, :sass

  # JavaScript minification
  set :assets_js_compressor, :uglifier

  # Register the AssetPipeline extension, make sure this goes after all customization
  register Sinatra::AssetPipeline

  # If you need more environments
  set :precompiled_environments, %i(staging uat production)

  get '/' do
    'hi'
  end
end
```
