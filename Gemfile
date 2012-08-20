source "http://rubygems.org"

# Specify your gem's dependencies in canard.gemspec
gemspec

group :development do
  gem 'debugger'
end

group :test do
  gem 'rake'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
gem "sqlite3", :platform => [:ruby, :mswin, :mingw], :group => [:development, :test]

platforms :ruby do
  group :mongoid do
    gem 'mongoid', '~> 3.0'
    gem 'bson_ext', '~> 1.6'
  end
end

# for JRuby
gem 'activerecord-jdbcsqlite3-adapter', :platform => [:jruby], :group => [:development, :test]
