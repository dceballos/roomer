# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "roomer/version"

Gem::Specification.new do |s|
  s.name        = "roomer"
  s.version     = Roomer::VERSION
  s.authors     = ["Greg Osuri","Daniel Ceballos"]
  s.email       = ["gosuri@gmail.com","dceballos@gmail.com"]
  s.homepage    = ""
  s.summary     = "A multi-tenant gem for Rails using Postgres"
  s.description = "A multi-tenant gem for Rails using Postgres"

  s.rubyforge_project = "roomer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec"

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"
end
