# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

require 'appraisal'

desc 'Run Roomer unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs    << 'lib'
  t.libs    << 'test'
  t.pattern =  'test/**/*_test.rb'
  t.verbose =  true
end

desc 'Run tests by default'
task :default => %w(test)
