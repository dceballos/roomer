# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "roomer/version"

Gem::Specification.new do |s|
  s.name        = "roomer"
  s.version     = Roomer::VERSION.dup
  s.platform    = Gem::Platform::RUBY  
  s.homepage    = "https://github.com/gosuri/roomer"
  s.summary     = "Roomer is a multitenant framework for Rails using PostgreSQL"
  s.description = "Roomer is a multitenant framework for Rails using PostgreSQL"
  s.rubyforge_project = s.name
  s.authors     = ["Greg Osuri","Daniel Ceballos"]
  s.email       = ["gosuri@gmail.com","dceballos@gmail.com"]
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.required_rubygems_version = ">= 1.3.4"
  s.add_development_dependency 'rspec', '~> 2.1.0'
  s.add_development_dependency 'rails', '~> 3.0.9'
  s.add_development_dependency 'rr',    '~> 0.10.11'
  s.add_development_dependency 'pg',    '~> 0.11.0'
end
