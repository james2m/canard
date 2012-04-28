gem 'minitest'
require 'minitest/autorun'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Rails.backtrace_cleaner.remove_silencers!

# Load support files (reloadable reloads canard)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + '/schema.rb')

