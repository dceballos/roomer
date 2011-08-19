source "http://rubygems.org"
gemspec

gem "rails", "~> 3.0.7"

group :doc do
  gem "yard"
end

group :test do
  gem "webrat", "0.7.2", :require => false
  gem "mocha", :require => false
end

platforms :ruby do
  group :db do
    gem "pg", ">= 0.11.0"
  end
end

platforms :jruby do
  gem "activerecord-jdbc-adapter"
end

platforms :mri_18 do
  group :test do
    gem "ruby-debug", ">= 0.10.3"
  end
end
