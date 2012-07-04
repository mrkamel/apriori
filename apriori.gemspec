# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "apriori/version"

Gem::Specification.new do |s|
  s.name        = "apriori"
  s.version     = Significance::VERSION
  s.authors     = ["Benjamin Vetter"]
  s.email       = ["vetter@flakks.com"]
  s.homepage    = ""
  s.summary     = %q{Another ruby apriori wrapper}
  s.description = %q{Another ruby apriori wrapper of Christian Borgelt's implementation}

  s.rubyforge_project = "apriori"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
end

