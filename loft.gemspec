# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'loft/version'

Gem::Specification.new do |s|
  s.name        = 'loft'
  s.version     = Loft::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Kravets']
  s.email       = 'alex@slatestudio.com'
  s.license     = 'MIT'
  s.homepage    = 'http://slatestudio.com'
  s.summary     = 'Media assets manager for Character CMS'
  s.description = <<-DESC
This plugin adds an assets library that provides an easy way
to upload, manage and insert files into documents.
  DESC

  s.rubyforge_project = 'loft'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency("mongoid_search",      ">= 0.3.1")
  s.add_dependency("mongoid-autoinc",     ">= 4.0.0")
  s.add_dependency("mini_magick",         ">= 4.1.0")
  s.add_dependency("mongoid-grid_fs",     ">= 2.1.0")
  s.add_dependency("carrierwave-mongoid", ">= 0.7.1")
end




