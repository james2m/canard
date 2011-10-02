require 'cancan'
require 'role_model'
require "canard/version"
require "canard/find_abilities"
require "ability"

module Canard
  autoload :UserModel, 'canard/user_model'
end

require 'canard/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

