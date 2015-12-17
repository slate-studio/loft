require "chr"
require "ants"
require "mongosteen"
require "mini_magick"
require "mongoid_search"
require "mongoid-grid_fs"
require "carrierwave/mongoid"

module Loft
  class Engine < ::Rails::Engine
    require "loft/engine"
    require "loft/routing"
  end
end
