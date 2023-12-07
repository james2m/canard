# frozen_string_literal: true

require 'rubygems'
require 'minitest/autorun'
require 'active_record'
require 'mongoid'

# Configure Rails Environment
environment  = ENV['RAILS_ENV'] = 'test'
rails_root   = File.expand_path('dummy', __dir__)
database_yml = File.expand_path('config/database.yml', rails_root)

ActiveRecord::Base.configurations = YAML.load_file(database_yml)

config = ActiveRecord::Base.configurations[environment]
db = File.expand_path(config['database'], rails_root)

# Drop the test database and migrate up
FileUtils.rm(db) if File.exist?(db)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db)
ActiveRecord::Base.connection
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.up File.expand_path('db/migrate', rails_root)

# Load mongoid config
Mongoid.load!(File.expand_path('config/mongoid3.yml', rails_root), :test)
Mongoid.logger.level = :info

# Load dummy rails app
require File.expand_path('config/environment.rb', rails_root)

Rails.backtrace_cleaner.remove_silencers!

# Load support files (reloadable reloads canard)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
