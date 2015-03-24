# Loft

## Character CMS media assets plugin

### Installation

Add to ```Gemfile```:

    gem 'loft'

Setup a new model for assets ```asset.rb```:

    class Asset
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::SerializableId
      include Mongoid::LoftAsset
    end

Add controller for asset model to make it accesible via CMS, e.g. ```app/controllers/admin/assets_controller.rb```:

    class Admin::AssetsController < Admin::BaseController
      mongosteen
      has_scope :by_type
      json_config({ methods: [ :list_item_thumbnail, :created_ago ] })
    end

Add admin assets controller to ```routes.rb```:

    resources :assets

Add to ```admin.scss```:

    @import "loft";

Add to ```admin.coffee``` character configuration object:

    assets: new Loft('Library', 'asset', '/admin/assets')


## Loft family

- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Character](https://github.com/slate-studio/chr): A simple and lightweight javascript library for building data management web apps
- [Inverter](https://github.com/slate-studio/inverter): An easy way to connect Rails templates content to CMS

## Credits

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Inverter is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.

## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Character is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).