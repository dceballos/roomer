# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "roomer/version"

Gem::Specification.new do |s|
  s.name        = "roomer"
  s.version     = Roomer::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "https://github.com/gosuri/roomer"
  s.summary     = "Roomer is a multitenant framework for Rails using PostgreSQL"
  s.description = Roomer::VERSION::SUMMARY

  s.authors     = ["Greg Osuri","Daniel Ceballos"]
  s.email       = ["gosuri@gmail.com","dceballos@gmail.com"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency  'rails','~> 3.0.9'
end
