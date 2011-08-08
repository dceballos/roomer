# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "roomer/version"

Gem::Specification.new do |s|
  s.name        = "roomer"
  s.version     = Roomer::VERSION.dup
  s.authors     = ["Greg Osuri","Daniel Ceballos"]
  s.email       = ["gosuri@gmail.com","dceballos@gmail.com"]
  s.homepage    = "https://github.com/gosuri/roomer"
  s.summary     = "A multi-tenant gem for Rails using Postgres"
  s.description = "A multi-tenant gem for Rails using Postgres"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec', '~> 2.1.0'
  s.add_development_dependency 'rails', '~> 3.0.9'
  s.add_development_dependency 'rr',    '~> 0.10.11'
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
