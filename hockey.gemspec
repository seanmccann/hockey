# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hockey/version'

Gem::Specification.new do |gem|
  gem.name          = "hockey"
  gem.version       = Hockey::VERSION
  gem.authors       = ["Sean McCann"]
  gem.email         = ["sean@intrans.com"]
  gem.description   = "Graphing key metrics to hit hockey stick growth"
  gem.summary       = "Graphing key metrics"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
