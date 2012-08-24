source "http://rubygems.org"

# Specify your gem's dependencies in canard.gemspec
gemspec

group :test do
  gem 'rake'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
group :development, :test do

  gem 'bson', "~> 1.6.4"

  platform :ruby, :mswin, :mingw do
    gem "sqlite3"
    gem "bson_ext", "~> 1.6.4"
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end

