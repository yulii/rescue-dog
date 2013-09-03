# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescue/version'

Gem::Specification.new do |gem|
  gem.name          = "rescue-dog"
  gem.version       = Rescue::VERSION
  gem.authors       = ["yulii"]
  gem.email         = ["yuliinfo@gmail.com"]
  gem.description   = %q{respond to an exception raised in Rails}
  gem.summary       = %q{define respond methods}
  gem.homepage      = "https://github.com/yulii/rescue-dog"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rails', '>= 3.2.11'
end
