# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescue/version'

Gem::Specification.new do |spec|
  spec.name          = 'rescue-dog'
  spec.version       = Rescue::VERSION
  spec.authors       = ['yulii']
  spec.email         = ['yone.info@gmail.com']

  spec.summary       = 'Responds status and error handling for Rails.'
  spec.description   = 'Declare simple CRUD and respond error methods.'
  spec.homepage      = 'https://github.com/yulii/rescue-dog'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'coveralls'
end
