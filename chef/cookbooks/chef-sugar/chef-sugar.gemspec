# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/sugar/version'

Gem::Specification.new do |spec|
  spec.name          = 'chef-sugar'
  spec.version       = Chef::Sugar::VERSION
  spec.authors       = ['Seth Vargo']
  spec.email         = ['sethvargo@gmail.com']
  spec.description   = 'A series of helpful sugar of the Chef core and ' \
                       'other resources to make a cleaner, more lean recipe ' \
                       'DSL, enforce DRY principles, and make writing Chef '  \
                       'recipes an awesome experience!'
  spec.summary       = 'A collection of helper methods and modules that '     \
                       'make working with Chef recipes awesome.'
  spec.homepage      = 'https://github.com/sethvargo/chef-sugar'
  spec.license       = 'Apache 2.0'

  spec.required_ruby_version = '>= 1.9'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'chefspec',        '~> 4.0'
  spec.add_development_dependency 'test-kitchen',    '~> 1.1'
  spec.add_development_dependency 'kitchen-vagrant', '~> 0.14'
end
