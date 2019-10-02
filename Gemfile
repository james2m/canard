# frozen_string_literal: true

source 'http://rubygems.org'

# Specify your gem's dependencies in canard.gemspec
gemspec

group :test do
  gem 'rake'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
group :development, :test do
  gem 'bson', '~> 1.6.4'
  gem 'rubocop'

  platform :ruby, :mswin, :mingw do
    gem 'bson_ext', '~> 1.6.4'
    gem 'sqlite3', '~> 1.3.5'
  end

  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end
