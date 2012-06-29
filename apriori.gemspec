# -*- encoding: utf-8 -*-
require File.expand_path('../lib/apriori/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Benjamin Vetter"]
  gem.email         = ["vetter@flakks.com"]
  gem.description   = %q{Another apriori wrapper}
  gem.summary       = %q{Another ruby apriori wrapper of Christian Borgelt's implementation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "apriori"
  gem.require_paths = ["lib"]
  gem.version       = Apriori::VERSION

  gem.add_development_dependency "rake"
end

