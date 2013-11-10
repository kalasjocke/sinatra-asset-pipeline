# sinatra-asset-pipeline

An asset pipeline implementation for Sinatra based on [Sprockets](https://github.com/sstephenson/sprockets) with support for CoffeeScript, SASS, SCSS, LESS, ERB as well as CSS (SASS, YUI) and JavaScript (uglifier, YUI, Closure) minification.

sinatra-asset-pipeline supports both compiling assets on the fly for development as well as precompiling assets for production.

# Installation

Include sinatra-asset-pipeline in your project's Gemfile:

```ruby
gem 'sinatra-asset-pipeline'
```

Make sure to add the sinatra-asset-pipeline Rake task in your applications `Rakefile`:

```ruby
require 'sinatra/asset_pipeline/task.rb'
require './app'

Sinatra::AssetPipeline::Task.define! App
```

Now, when everything is in place you can precompile assets located in `assets/<asset-type>` with: 

```bash
$ RAKE_ENV=production rake assets:precompile
```

And remove old compiled assets with:

```bash
$ RAKE_ENV=production rake assets:clean
```

# Example

In it's most simple form you just register the `Sinatra::AssetPipeline` Sinatra extension within your Sinatra app:

```ruby
Bundler.require

require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    haml :index
  end
end
```

However, if your application doesn't follow the defaults you can customize it as follows:

```ruby
Bundler.require

require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  # Include these files when precompiling assets
  set :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff)

  # Logical paths to your assets
  set :assets_prefix, %w(assets, vendor/assets)

  # Use another host for serving assets
  set :assets_host, '<id>.cloudfront.net'

  # Serve assets using this protocol
  set :assets_protocol, :http

  # CSS minification
  set :assets_css_compressor, :sass

  # JavaScript minification
  set :assets_js_compressor, :uglifier

  # Register the AssetPipeline extention, make sure this goes after all customization
  register Sinatra::AssetPipeline

  get '/' do
    haml :index
  end
end
```

Now when everything is in place you can use all helpers provided by [sprockets-helpers](https://github.com/petebrowne/sprockets-helpers), here is a small example:

```scss
body {
  background-image: image-url('cat.png');
}
```

You do *NOT* need to `require` sprockets-helpers in your app file to benefit from the sprocket-helpers integration. 
If you do `require 'sprockets-helpers'`, this may lead to the following error: 

```
NameError: uninitialized constant Sinatra::Sprockets::Environment
```

sinatra-asset-pipeline provides all the necessary integration for sprockets-helpers to be setup for your app.

### CSS and JavaScript minification

If you would like to use CSS and/or JavaScript minification make sure to require the gems needed in your `Gemfile`:

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

### Compass integration

Given that we're using [sprockets-sass](https://github.com/petebrowne/sprockets-sass) under the hood we have out of the box support for [compass](https://github.com/chriseppstein/compass). Just include the compass gem in your `Gemfile` and include the compass mixins in your `app.css.scss` file.

