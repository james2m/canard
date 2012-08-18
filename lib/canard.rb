require 'cancan'
require 'role_model'
require 'canard/abilities'
require 'canard/version'
require 'canard/user_model'
require "canard/find_abilities"
require "ability"

module Canard
  mattr_accessor :is_setup
  
  def self.setup
    yield self
    
    require 'canard/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
    
    unless defined?(Canard::Adapters)
      require 'canard/adapters/active_record' if defined?(ActiveRecord)
      require 'canard/adapters/mongoid' if defined?(Mongoid)
    end
    
    self.is_setup = true
  end
end
