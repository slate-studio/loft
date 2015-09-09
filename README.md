# Loft

*Media assets manager for [Character CMS](https://github.com/slate-studio/chr).*


### Installation

Add to ```Gemfile```:

    gem 'loft'

Add admin assets controller to ```routes.rb```:

```ruby
resources :assets, controller: 'assets'
```

Add to ```admin.scss``` and ```admin.coffee```:

```scss
@import "loft";
```

```coffee
#= require loft
```

Add to ```admin.coffee``` character configuration object:

```coffee
loft: new Loft('Files', 'asset', '/admin/assets')
```


## TODO Notes

1. Check out [kraken.io](https://github.com/kraken-io/kraken-ruby) for image optimization.


## Loft family

- [Character](https://github.com/slate-studio/chr): Powerful javascript CMS for apps
- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Inverter](https://github.com/slate-studio/inverter): An easy way to connect Rails templates content to CMS


## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Loft is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).


## About Slate Studio

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Loft is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.