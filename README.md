# Loft

*Media assets manager for [Character CMS](https://github.com/slate-studio/chr).*


### Installation

Add to ```Gemfile```:

    gem 'loft'

Setup a new model for assets ```asset.rb```:

```ruby
class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SerializableId
  include Mongoid::LoftAsset
end
```

Add controller for asset model to make it accesible via CMS, e.g. ```app/controllers/admin/assets_controller.rb```:

```ruby
class Admin::AssetsController < Admin::BaseController
  mongosteen
  has_scope :by_type
  json_config({ methods: [ :item_thumbnail, :created_ago ] })
end
```

Add admin assets controller to ```routes.rb```:

```ruby
resources :assets
```

Add to ```admin.scss```:

```scss
@import "loft";
```

Add to ```admin.coffee``` character configuration object:

```coffee
loft: new Loft('Files', 'asset', '/admin/assets')
```


## Loft family

- [Character](https://github.com/slate-studio/chr): Powerful javascript CMS for apps
- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Inverter](https://github.com/slate-studio/inverter): An easy way to connect Rails templates content to CMS


## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Loft is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).


## About Slate Studio

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Loft is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.