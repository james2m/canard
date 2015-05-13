require 'forwardable'
require 'cancan'
require 'role_model'
require 'canard/abilities'
require 'canard/version'
require 'canard/user_model'
require "canard/find_abilities"
require "ability"

require 'canard/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
