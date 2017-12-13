# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josep Batallé"]
  gem.email         = ["josep.batalle@i2cat.net"]
  gem.description   = %q{T-Nova auth.}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "auth"
  gem.require_paths = ["lib"]
  gem.version       = Auth::VERSION

  gem.add_dependency 'sinatra', '1.4'
end
