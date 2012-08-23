source "http://rubygems.org"

# Specify your gem's dependencies in canard.gemspec
gemspec

group :development do
  gem 'ruby-debug', :platform => :ruby_18
  gem 'debugger', :platform => :ruby_19
end

group :test do
  gem 'rake'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
gem "sqlite3", :platform => [:ruby, :mswin, :mingw], :group => [:development, :test]

# for JRuby
gem 'activerecord-jdbcsqlite3-adapter', :platform => [:jruby], :group => [:development, :test]
